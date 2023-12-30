import 'package:flutter/material.dart';
import 'package:marketsnapp/screens/profile_screen.dart';
import 'package:marketsnapp/screens/token_detail_screen.dart';
import 'package:marketsnapp/widgets/cryptocurrency_price_text_screen.dart';
import 'package:marketsnapp/widgets/portfolio_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:marketsnapp/api/cryptocurrency.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/utils/moneyFormatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late IO.Socket socket;
  int currentPage = 1;
  List<CryptoRecord> cryptocurrencies = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  String portfolioUpdateToday = ' up +\$874.5 (7%) ';
  String dropdownValue = '24 Hours';
  String timePeriod = 'today.';

  @override
  void initState() {
    super.initState();
    initSocket();
    _fetchData();
    _scrollController.addListener(_scrollListener);
  }

  void initSocket() {
    socket =
        IO.io('http://192.168.0.102:5000/cryptocurrency', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.on('connect', (_) {});

    socket.on('marketData', (marketData) {
      marketData.forEach((symbol, data) {
        int index =
            cryptocurrencies.indexWhere((element) => element.symbol == symbol);
        if (index != -1) {
          if (mounted) {
            final updatedCryptocurrency = CryptoRecord(
              symbol: cryptocurrencies[index].symbol,
              name: cryptocurrencies[index].name,
              icon: cryptocurrencies[index].icon,
              decimal: cryptocurrencies[index].decimal,
              circulatingSupply: cryptocurrencies[index].circulatingSupply,
              totalSupply: cryptocurrencies[index].totalSupply,
              maxSupply: cryptocurrencies[index].maxSupply,
              price: data['price'].toDouble(),
              marketCap: data['market_cap'].toDouble(),
              priceChange: data['price_change'].toDouble(),
              priceChangePercent: data['price_change_percent'].toDouble(),
              openPrice: data['open_price'].toDouble(),
              highPrice: data['high_price'].toDouble(),
              lowPrice: data['low_price'].toDouble(),
              volume: data['volume'].toDouble(),
              isLastPriceUp: data['is_last_price_up'],
            );

            setState(() {
              cryptocurrencies[index] = updatedCryptocurrency;
            });
          }
        }
      });
    });

    socket.on('disconnect', (_) {});
  }

  void _fetchData() async {
    if (isLoading) return;
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      var newCryptoData =
          await getAllCryptocurrencies(currentPage, dropdownValue);
      if (mounted) {
        setState(() {
          cryptocurrencies.addAll(newCryptoData.data);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      currentPage++;
      socket.emit('changePage', currentPage);
      _fetchData();
    }
  }

  Future<void> _refresh() async {
    currentPage = 1;
    cryptocurrencies.clear();
    _fetchData();
  }

  @override
  void dispose() {
    socket.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome ${profileScreen.email}!',
                style: Header2(),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          const HomeScreenPortfolioWidget(),
          const SizedBox(
            height: 4.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Market', style: Header3()),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: primaryColor,
                  ),
                  dropdownColor: primaryColor,
                  underline: Container(
                    height: 2,
                    color: primaryColor,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      switch (newValue) {
                        case '1 Hour':
                          socket.emit('changeWindowSize', "1h");
                          timePeriod = 'last hour.';
                          break;
                        case '24 Hours':
                          socket.emit('changeWindowSize', "1d");
                          timePeriod = 'today.';
                          break;
                        case '7 Days':
                          socket.emit('changeWindowSize', "7d");
                          timePeriod = 'this week.';
                          break;
                      }
                      _fetchData();
                    });
                    _refresh();
                  },
                  items: <String>['1 Hour', '24 Hours', '7 Days']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Header3(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: cryptocurrencies.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < cryptocurrencies.length) {
                      var record = cryptocurrencies[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TokenDetailScreen(
                                cryptoData: record,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: index == 0
                              ? const EdgeInsets.only(bottom: 4.0)
                              : index == cryptocurrencies.length - 1
                                  ? const EdgeInsets.only(top: 4.0)
                                  : const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: imagePaddingBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: NetworkImage(
                                    "https://s2.coinmarketcap.com/static/img/coins/64x64/${record.icon}.png",
                                  ),
                                  backgroundColor: whiteColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.symbol,
                                      style: Header3(),
                                    ),
                                    Text(
                                      formatMoney(record.marketCap),
                                      style: InputPlaceholder(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CryptoPriceText(
                                      priceText: formatCurrency(
                                          record.price, record.decimal),
                                      isLastPriceUp:
                                          record.isLastPriceUp ?? false,
                                    ),
                                    Text(
                                      ' ${record.priceChangePercent > 0 ? '+' : ''}${formatCurrency(record.priceChange, record.decimal)} (${record.priceChangePercent.abs()}%) ',
                                      style: record.priceChangePercent >= 0
                                          ? UpText()
                                          : DownText(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
