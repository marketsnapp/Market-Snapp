import 'package:flutter/material.dart';
import 'package:marketsnapp/screens/token_detail_screen.dart';
import 'package:marketsnapp/utils/getPriceChangeData.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/providers/cryptocurrency_provider.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/utils/moneyFormatter.dart';
import 'package:marketsnapp/widgets/cryptocurrency_price_text_screen.dart';

class HomeScreenMarketWidget extends StatefulWidget {
  const HomeScreenMarketWidget({super.key});

  @override
  _HomeScreenMarketWidgetState createState() => _HomeScreenMarketWidgetState();
}

class _HomeScreenMarketWidgetState extends State<HomeScreenMarketWidget>
    with SingleTickerProviderStateMixin {
  late IO.Socket socket;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  String windowSize = '24 Hours';

  @override
  void initState() {
    super.initState();
    initSocket();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CryptocurrencyProvider>(context, listen: false)
          .fetchWatchlist();
    });
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
      if (mounted) {
        Provider.of<CryptocurrencyProvider>(context, listen: false)
            .updateCryptocurrencyFromSocket(marketData, windowSize);
      }
    });

    socket.on('disconnect', (_) {});
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        currentPage++;
      });
    }
  }

  Widget tableHeader() {
    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Symbol',
            style: spaceGroteskStyle(16, FontWeight.w400, whiteColor),
          ),
          DropdownButton<String>(
            value: windowSize,
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
                windowSize = newValue!;
                switch (newValue) {
                  case '1 Hour':
                    socket.emit('changeWindowSize', "1h");
                    break;
                  case '24 Hours':
                    socket.emit('changeWindowSize', "1d");
                    break;
                  case '7 Days':
                    socket.emit('changeWindowSize', "7d");
                    break;
                }
                Provider.of<CryptocurrencyProvider>(context, listen: false)
                    .fetchCryptocurrencies(windowSize);
              });
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
    );
  }

  void handleTap(CryptocurrencyRecord cryptocurrency) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TokenDetailScreen(
          cryptocurrency: cryptocurrency,
        ),
      ),
    ).then((_) {
      if (!socket.connected) {
        socket.connect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var cryptoProvider = Provider.of<CryptocurrencyProvider>(context);
    var paginatedCryptocurrencies =
        cryptoProvider.getPaginatedCryptocurrencies(currentPage);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorColor: primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            labelPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            unselectedLabelColor: whiteColor,
            labelStyle: spaceGroteskStyle(16, FontWeight.w700, whiteColor),
            unselectedLabelStyle:
                spaceGroteskStyle(16, FontWeight.w400, whiteColor),
            tabs: [
              Container(
                padding: const EdgeInsets.only(right: 8),
                child: const Tab(text: 'Market'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Tab(text: 'Watchlist'),
              ),
            ],
          ),
          tableHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: paginatedCryptocurrencies.length,
                  itemBuilder: (context, index) {
                    var cryptocurrency = paginatedCryptocurrencies[index];
                    var priceChangeData =
                        getPriceChangeData(cryptocurrency, windowSize);

                    if (priceChangeData == null) {
                      return const CircularProgressIndicator(
                        color: primaryColor,
                      );
                    } else {
                      return cryptocurrencyCard(
                        cryptocurrency,
                        priceChangeData,
                        handleTap,
                      );
                    }
                  },
                ),
                ListView.builder(
                  itemCount:
                      cryptoProvider.watchListedCryptocurrencyIDList.length,
                  itemBuilder: (context, index) {
                    var cryptocurrency =
                        cryptoProvider.cryptocurrencies.firstWhere(
                      (element) =>
                          element.id ==
                          cryptoProvider.watchListedCryptocurrencyIDList[index],
                    );
                    var priceChangeData =
                        getPriceChangeData(cryptocurrency, windowSize);

                    if (priceChangeData == null) {
                      return const CircularProgressIndicator(
                        color: primaryColor,
                      );
                    } else {
                      return cryptocurrencyCard(
                        cryptocurrency,
                        priceChangeData,
                        handleTap,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

Widget cryptocurrencyCard(
    CryptocurrencyRecord cryptocurrency,
    PriceChangeData priceChangeData,
    void Function(CryptocurrencyRecord) handleTap) {
  return InkWell(
    onTap: () => handleTap(cryptocurrency),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              "https://s2.coinmarketcap.com/static/img/coins/64x64/${cryptocurrency.icon}.png",
            ),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cryptocurrency.symbol,
                  style: Header3(),
                ),
                Text(
                  formatMoney(cryptocurrency.marketCap),
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
                      cryptocurrency.price, cryptocurrency.decimal ?? 2),
                  isLastPriceUp: cryptocurrency.isLastPriceUp ?? false,
                ),
                Text(
                  '${priceChangeData.priceChangePercent.abs().toStringAsFixed(2)}%',
                  style: priceChangeData.priceChangePercent >= 0
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
}
