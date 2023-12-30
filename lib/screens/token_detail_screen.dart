import 'package:flutter/material.dart';
import 'package:marketsnapp/api/cryptocurrency.dart';
import 'package:marketsnapp/utils/windowSizeFormatter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/utils/moneyFormatter.dart';
import 'package:marketsnapp/widgets/cryptocurrency_price_text_screen.dart';

class TokenDetailScreen extends StatefulWidget {
  final CryptoRecord cryptoData;
  const TokenDetailScreen({Key? key, required this.cryptoData})
      : super(key: key);

  @override
  State<TokenDetailScreen> createState() => _TokenDetailScreenState();
}

class _TokenDetailScreenState extends State<TokenDetailScreen> {
  late IO.Socket socket;
  bool isLoading = false;
  late CryptoRecord cryptocurrency;

  int _selectedRangeIndex = 1;
  String _selectedChartType = 'linechart';

  final List<String> _timeRanges = [
    '1 Hour',
    '24 Hours',
    '7 Days',
  ];

  void _fetchData() async {
    if (isLoading) return;
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      var newCryptoData = await getCryptocurrency(
          cryptocurrency.symbol, _timeRanges[_selectedRangeIndex]);
      print(newCryptoData.data);
      if (mounted) {
        setState(() {
          cryptocurrency = newCryptoData.data[0];
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void initSocket() {
    socket =
        IO.io('http://192.168.0.102:5000/cryptocurrency', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'symbol': cryptocurrency.symbol},
    });

    socket.connect();
    socket.on('connect', (_) {
      print('Connected to socket');
    });

    socket.on('marketData', (marketData) {
      if (mounted) {
        final updatedCryptocurrency = CryptoRecord(
          symbol: cryptocurrency.symbol,
          name: cryptocurrency.name,
          icon: cryptocurrency.icon,
          decimal: cryptocurrency.decimal,
          circulatingSupply: cryptocurrency.circulatingSupply,
          totalSupply: cryptocurrency.totalSupply,
          maxSupply: cryptocurrency.maxSupply,
          price: marketData['price'].toDouble(),
          marketCap: marketData['market_cap'].toDouble(),
          priceChange: marketData['price_change'].toDouble(),
          priceChangePercent: marketData['price_change_percent'].toDouble(),
          openPrice: marketData['open_price'].toDouble(),
          highPrice: marketData['high_price'].toDouble(),
          lowPrice: marketData['low_price'].toDouble(),
          volume: marketData['volume'].toDouble(),
          isLastPriceUp: marketData['is_last_price_up'],
        );

        setState(() => cryptocurrency = updatedCryptocurrency);
      }
    });

    socket.on('disconnect', (_) {
      print('Disconnected from socket');
    });
  }

  @override
  void initState() {
    super.initState();
    cryptocurrency = widget.cryptoData;
    _fetchData();
    initSocket();
  }

  Future<void> _refresh() async {
    cryptocurrency = widget.cryptoData;
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: whiteColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.star,
              color: primaryColor,
            ),
            onPressed: () => setState(() {}),
          ),
        ],
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Text(
              cryptocurrency.name,
              style: Header3(),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              cryptocurrency.symbol,
              style: InputPlaceholder(),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CryptoPriceText(
                              priceText: formatCurrency(
                                  cryptocurrency.price, cryptocurrency.decimal),
                              isLastPriceUp:
                                  cryptocurrency.isLastPriceUp ?? false,
                              isHeader: true,
                            ),
                            Text(
                              ' ${cryptocurrency.priceChangePercent > 0 ? '+' : ''}${formatCurrency(cryptocurrency.priceChange, cryptocurrency.decimal)} (${cryptocurrency.priceChangePercent.abs()}%) ',
                              style: cryptocurrency.priceChangePercent >= 0
                                  ? UpText()
                                  : DownText(),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: imagePaddingBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              "https://s2.coinmarketcap.com/static/img/coins/64x64/${cryptocurrency.icon}.png",
                            ),
                            backgroundColor: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    color: backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ..._timeRanges.asMap().entries.map((entry) {
                              int idx = entry.key;
                              String timeRange = entry.value;
                              bool isSelected = _selectedRangeIndex == idx;
                              return Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      side: const BorderSide(
                                        color: imagePaddingBackgroundColor,
                                      ),
                                      foregroundColor: isSelected
                                          ? whiteColor
                                          : whiteColorOpacity55,
                                      backgroundColor: isSelected
                                          ? primaryColor
                                          : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                    ),
                                    child: Text(timeRange),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          _selectedRangeIndex = idx;
                                        });
                                        socket.emit(
                                          'changeWindowSize',
                                          windowSizeFormatter(timeRange),
                                        );
                                        _fetchData();
                                      }
                                    },
                                  ),
                                  if (idx != 2) const SizedBox(width: 4),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                side: const BorderSide(
                                  color: imagePaddingBackgroundColor,
                                ),
                                foregroundColor:
                                    _selectedChartType == 'candlestick'
                                        ? whiteColor
                                        : whiteColorOpacity55,
                                backgroundColor:
                                    _selectedChartType == 'candlestick'
                                        ? primaryColor
                                        : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              child: Icon(
                                Icons.candlestick_chart_sharp,
                                color: _selectedChartType == 'candlestick'
                                    ? whiteColor
                                    : whiteColorOpacity55,
                              ),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    _selectedChartType = 'candlestick';
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              style: TextButton.styleFrom(
                                side: const BorderSide(
                                  color: imagePaddingBackgroundColor,
                                ),
                                foregroundColor:
                                    _selectedChartType == 'linechart'
                                        ? whiteColor
                                        : whiteColorOpacity55,
                                backgroundColor:
                                    _selectedChartType == 'linechart'
                                        ? primaryColor
                                        : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              child: Icon(
                                Icons.stacked_line_chart_sharp,
                                color: _selectedChartType == 'linechart'
                                    ? whiteColor
                                    : whiteColorOpacity55,
                              ),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    _selectedChartType = 'linechart';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 290,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MarketDataTile(
                              title:
                                  'Volume (${_timeRanges[_selectedRangeIndex]})',
                              value: formatMoney(cryptocurrency.marketCap),
                            ),
                          ),
                          Expanded(
                            child: MarketDataTile(
                              title: 'Market Cap',
                              value: formatMoney(cryptocurrency.marketCap),
                            ),
                          ),
                          Expanded(
                            child: MarketDataTile(
                              title: 'Fully Diluted M.Cap',
                              value: formatMoney(cryptocurrency.maxSupply *
                                  cryptocurrency.price),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MarketDataTile(
                              title: 'Circulating Supply',
                              value: formatMoney(
                                  cryptocurrency.circulatingSupply, false),
                            ),
                          ),
                          Expanded(
                            child: MarketDataTile(
                              title: 'Total Supply',
                              value: formatMoney(
                                  cryptocurrency.totalSupply, false),
                            ),
                          ),
                          Expanded(
                            child: MarketDataTile(
                              title: 'Max Supply',
                              value:
                                  formatMoney(cryptocurrency.maxSupply, false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MarketDataTile(
                              title:
                                  'Open (${_timeRanges[_selectedRangeIndex]})',
                              value: formatCurrency(cryptocurrency.openPrice,
                                  cryptocurrency.decimal),
                            ),
                          ),
                          Expanded(
                            child: MarketDataTile(
                              title:
                                  'Low (${_timeRanges[_selectedRangeIndex]})',
                              value: formatCurrency(cryptocurrency.lowPrice,
                                  cryptocurrency.decimal),
                            ),
                          ),
                          Expanded(
                            child: MarketDataTile(
                              title:
                                  'High (${_timeRanges[_selectedRangeIndex]})',
                              value: formatCurrency(cryptocurrency.highPrice,
                                  cryptocurrency.decimal),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MarketDataTile extends StatelessWidget {
  final String title;
  final String value;

  const MarketDataTile({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: DetailPageCardHeader(),
        ),
        const SizedBox(height: 2.0),
        Text(
          value,
          style: Header3(),
        ),
      ],
    );
  }
}
