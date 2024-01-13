import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketsnapp/providers/cryptocurrency_provider.dart';
import 'package:marketsnapp/screens/add_transaction_screen.dart';
import 'package:marketsnapp/types/historicaldata.dart';
import 'package:marketsnapp/utils/getPriceChangeData.dart';
import 'package:provider/provider.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/utils/moneyFormatter.dart';
import 'package:marketsnapp/widgets/cryptocurrency_price_text_screen.dart';

class TokenDetailScreen extends StatefulWidget {
  final CryptocurrencyRecord cryptocurrency;
  const TokenDetailScreen({Key? key, required this.cryptocurrency})
      : super(key: key);

  @override
  State<TokenDetailScreen> createState() => _TokenDetailScreenState();
}

class _TokenDetailScreenState extends State<TokenDetailScreen> {
  String windowSize = '24 Hours';
  PriceChangeData? priceChangeData;
  Future? _fetchFuture;

  final List<String> _timeRanges = [
    '1 Hour',
    '24 Hours',
    '7 Days',
  ];

  String getXAxisLabel(DateTime date, String windowSize) {
    if (windowSize == '1 Hour') {
      return DateFormat.Hm().format(date); // Hours and minutes
    } else if (windowSize == '24 Hours' || windowSize == '7 Days') {
      return DateFormat.MMMd().format(date); // Month day
    } else {
      return ''; // Default case or error
    }
  }

  late Future<HistoricalData> _fetchHistoricalDataFuture;
  @override
  void initState() {
    super.initState();
    _fetchFuture = Provider.of<CryptocurrencyProvider>(context, listen: false)
        .fetchCryptocurrency(widget.cryptocurrency.symbol, windowSize);

    _fetchHistoricalDataFuture =
        fetchHistoricalData(widget.cryptocurrency.symbol, windowSize);
  }

  @override
  Widget build(BuildContext context) {
    bool isWatchlisted = Provider.of<CryptocurrencyProvider>(context)
        .isCryptocurrencyWatchlisted(widget.cryptocurrency.id);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: whiteColor,
        ),
        actions: [
          IconButton(
            icon: isWatchlisted
                ? const Icon(
                    Icons.star_rounded,
                    color: primaryColor,
                  )
                : const Icon(
                    Icons.star_outline_rounded,
                    color: whiteColor,
                  ),
            onPressed: () {
              if (isWatchlisted) {
                Provider.of<CryptocurrencyProvider>(context, listen: false)
                    .removeWatchlist(widget.cryptocurrency.id);
              } else {
                Provider.of<CryptocurrencyProvider>(context, listen: false)
                    .addWatchlist(widget.cryptocurrency.id);
              }
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Text(
              widget.cryptocurrency.name!,
              style: Header3(),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              widget.cryptocurrency.symbol,
              style: InputPlaceholder(),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _fetchFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: primaryColor,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var cryptocurrency =
                  Provider.of<CryptocurrencyProvider>(context, listen: false)
                      .findCryptocurrency(widget.cryptocurrency.id);

              PriceChangeData? priceChangeData =
                  getPriceChangeData(cryptocurrency, windowSize);

              return ListView(
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
                                      cryptocurrency.price,
                                      cryptocurrency.decimal!),
                                  isLastPriceUp:
                                      cryptocurrency.isLastPriceUp ?? false,
                                  isHeader: true,
                                ),
                                Text(
                                  ' ${priceChangeData!.priceChangePercent > 0 ? '+' : ''}${formatCurrency(priceChangeData.priceChange, cryptocurrency.decimal!)} (${priceChangeData.priceChangePercent.abs()}%) ',
                                  style: priceChangeData.priceChangePercent >= 0
                                      ? UpText()
                                      : DownText(),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                "https://s2.coinmarketcap.com/static/img/coins/64x64/${cryptocurrency.icon}.png",
                              ),
                              backgroundColor: whiteColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        color: backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ..._timeRanges.asMap().entries.map((entry) {
                              int idx = entry.key;
                              String timeRange = entry.value;
                              bool isSelected = windowSize == timeRange;
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
                                          windowSize = timeRange;
                                          _fetchFuture = Provider.of<
                                              CryptocurrencyProvider>(
                                            context,
                                            listen: false,
                                          ).fetchCryptocurrency(
                                            widget.cryptocurrency.symbol,
                                            timeRange,
                                          );

                                          _fetchHistoricalDataFuture =
                                              fetchHistoricalData(
                                                  widget.cryptocurrency.symbol,
                                                  windowSize);
                                        });
                                      }
                                    },
                                  ),
                                  if (idx != 2) const SizedBox(width: 16),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      FutureBuilder<HistoricalData>(
                        future: _fetchHistoricalDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.priceData.isEmpty) {
                            return const Text('No data available');
                          }

                          var priceData = snapshot.data!.priceData;
                          double minY =
                              priceData.map((e) => e.closePrice).reduce(min);
                          double maxY =
                              priceData.map((e) => e.closePrice).reduce(max);

                          if (windowSize == "1 Hour") {
                            minY *= 0.995;
                            maxY *= 1.005;
                          } else if (windowSize == "24 Hours") {
                            minY *= 0.98;
                            maxY *= 1.02;
                          } else {
                            minY *= 0.96;
                            maxY *= 1.04;
                          }

                          List<FlSpot> spots = priceData
                              .asMap()
                              .entries
                              .map((e) =>
                                  FlSpot(e.key.toDouble(), e.value.closePrice))
                              .toList();

                          double minX = 0;
                          double maxX = spots.length.toDouble() - 1;

                          double verticalInterval = spots.length / 12;
                          double horizontalInterval = (maxY - minY) / 4;

                          int estimatedTextLength = maxY
                              .toStringAsFixed(
                                  widget.cryptocurrency.decimal ?? 2)
                              .length;
                          double reservedSize = estimatedTextLength * 8;

                          return SizedBox(
                            height: 250,
                            child: LineChart(
                              LineChartData(
                                minX: minX,
                                maxX: maxX,
                                minY: minY,
                                maxY: maxY,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  verticalInterval: verticalInterval,
                                  horizontalInterval: horizontalInterval,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: whiteColor.withOpacity(0.1),
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: whiteColor.withOpacity(0.1),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        if (value == minY || value == maxY) {
                                          String text = value.toStringAsFixed(
                                              widget.cryptocurrency.decimal ??
                                                  2);

                                          return Text(
                                            text,
                                            style: spaceGroteskStyle(
                                              12,
                                              FontWeight.normal,
                                              whiteColor,
                                            ),
                                            textAlign: TextAlign.right,
                                          );
                                        } else {
                                          return const Text('');
                                        }
                                      },
                                      reservedSize: reservedSize,
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        if (value.toInt() >= 0 &&
                                            value.toInt() < priceData.length) {
                                          final DateTime date =
                                              priceData[value.toInt()].openTime;
                                          var text = '';
                                          if (value.toInt() % (12) == 0 ||
                                              value.toInt() ==
                                                  priceData.length - 1) {
                                            text =
                                                getXAxisLabel(date, windowSize);
                                          }
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            space: 8.0,
                                            child: Text(
                                              text,
                                              style: spaceGroteskStyle(
                                                12,
                                                FontWeight.normal,
                                                whiteColor,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const Text('');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    color: primaryColor,
                                    barWidth: 1,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: primaryColor.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: MarketDataTile(
                                  title: 'Volume ($windowSize)',
                                  value: formatMoney(priceChangeData.volume!),
                                ),
                              ),
                              Expanded(
                                child: MarketDataTile(
                                  title: 'Market Cap',
                                  value: formatMoney(cryptocurrency.marketCap),
                                ),
                              ),
                              Expanded(
                                child: cryptocurrency.maxSupply == -1
                                    ? const MarketDataTile(
                                        title: 'Fully Diluted M.Cap',
                                        value: "Inifitiy",
                                      )
                                    : cryptocurrency.maxSupply == 0
                                        ? const MarketDataTile(
                                            title: 'Fully Diluted M.Cap',
                                            value: "No Data",
                                          )
                                        : MarketDataTile(
                                            title: 'Fully Diluted M.Cap',
                                            value: formatMoney(
                                                cryptocurrency.maxSupply! *
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
                                    cryptocurrency.circulatingSupply!,
                                    false,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MarketDataTile(
                                  title: 'Total Supply',
                                  value: formatMoney(
                                    cryptocurrency.totalSupply!,
                                    false,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: cryptocurrency.maxSupply == -1
                                    ? const MarketDataTile(
                                        title: 'Max Supply',
                                        value: "Inifitiy",
                                      )
                                    : cryptocurrency.maxSupply == 0
                                        ? const MarketDataTile(
                                            title: 'Max Supply',
                                            value: "No Data",
                                          )
                                        : MarketDataTile(
                                            title: 'Max Supply',
                                            value: formatMoney(
                                                cryptocurrency.maxSupply!,
                                                false),
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
                                  title: 'Open ($windowSize)',
                                  value: formatCurrency(
                                    priceChangeData.openPrice!,
                                    cryptocurrency.decimal!,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MarketDataTile(
                                  title: 'Low ($windowSize)',
                                  value: formatCurrency(
                                    priceChangeData.lowPrice!,
                                    cryptocurrency.decimal!,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MarketDataTile(
                                  title: 'High ($windowSize)',
                                  value: formatCurrency(
                                    priceChangeData.highPrice!,
                                    cryptocurrency.decimal!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          visualDensity: const VisualDensity(),
                          backgroundColor: primaryColor,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTransactionScreen(
                                cryptocurrency: cryptocurrency,
                              ),
                            ),
                          );
                        },
                        child: Text("Add Transaction", style: Header2()),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
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
