import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/providers/cryptocurrency_provider.dart';
import 'package:marketsnapp/providers/portfolio_provider.dart';
import 'package:marketsnapp/screens/search_screen.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/types/portfolio.dart';
import 'package:marketsnapp/utils/appBarBuilder.dart';
import 'package:marketsnapp/utils/bottomNavigationBarBuilder.dart';
import 'package:marketsnapp/utils/getPriceChangeData.dart';
import 'package:marketsnapp/utils/moneyFormatter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class PortfolioScreen extends StatefulWidget {
  static const String id = 'portfolio';

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
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
          Text(
            'Assets',
            style: spaceGroteskStyle(16, FontWeight.w400, whiteColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final cryptocurrencyProvider = Provider.of<CryptocurrencyProvider>(context);

    Map<String, double> pieChartData =
        portfolioProvider.createHoldingsPieChartData(cryptocurrencyProvider);

    bool hasData = pieChartData.isNotEmpty;

    return Scaffold(
      appBar: appBarBuilder(context, PortfolioScreen.id),
      bottomNavigationBar:
          bottomNavigationBarBuilder(context, PortfolioScreen.id),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatCurrency(portfolioProvider.totalPortfolioValue, 2),
                style: Header1(),
              ),
              Text(
                "${formatCurrency(portfolioProvider.totalProfit, 2)} (${formatMoney(portfolioProvider.totalChange, false)}%)",
                style: portfolioProvider.totalProfit > 0
                    ? spaceGroteskStyle(20, FontWeight.w400, greenColor)
                    : spaceGroteskStyle(20, FontWeight.w400, redColor),
              ),
              Expanded(
                flex: 1,
                child: hasData
                    ? PieChart(
                        dataMap: pieChartData,
                        chartType: ChartType.ring,
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          legendTextStyle: Body(),
                        ),
                      )
                    : Center(
                        child: Text('No data available for Pie Chart'),
                      ),
              ),
              tableHeader(),
              Expanded(
                child: ListView.builder(
                  itemCount: portfolioProvider.portfolio.holdings.length,
                  itemBuilder: (context, index) {
                    final holding = portfolioProvider.portfolio.holdings[index];
                    final cryptocurrency =
                        cryptocurrencyProvider.cryptocurrencies.firstWhere(
                            (crypto) => crypto.id == holding.cryptocurrencyId);
                    var priceChangeData =
                        getPriceChangeData(cryptocurrency, "24 Hours");

                    if (priceChangeData == null) {
                      return const CircularProgressIndicator(
                        color: primaryColor,
                      );
                    } else {
                      return cryptocurrencyCard(
                          holding, cryptocurrency, priceChangeData);
                    }
                  },
                ),
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
                  Navigator.pushNamed(context, SearchScreen.id);
                },
                child: Text("Add Transaction", style: Header2()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget cryptocurrencyCard(
  Holding holding,
  CryptocurrencyRecord cryptocurrency,
  PriceChangeData priceChangeData,
) {
  return InkWell(
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
                  "${formatMoney(holding.profit, false)} (${formatMoney(holding.profit > 0 ? ((cryptocurrency.price / holding.averagePurchasePrice) - 1) * 100 : (1 - (cryptocurrency.price / holding.averagePurchasePrice)) * 100, false)}%)",
                  style: holding.profit > 0 ? UpText() : DownText(),
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
                Text(
                  formatCurrency(holding.currentValue, 2),
                  style: Header3(),
                ),
                Text(
                  "${formatMoney(holding.amount, false)} ${cryptocurrency.symbol}",
                  style: InputPlaceholder(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
