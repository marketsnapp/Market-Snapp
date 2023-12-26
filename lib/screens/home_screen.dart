import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketsnapp/api/cryptocurrencies.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/cryptocurrencies.dart';

String formatMoney(double amount) {
  if (amount >= 1e9) {
    return '\$${(amount / 1e9).toStringAsFixed(1)}B';
  } else if (amount >= 1e6) {
    return '\$${(amount / 1e6).toStringAsFixed(1)}M';
  } else if (amount >= 1e3) {
    return '\$${(amount / 1e3).toStringAsFixed(1)}K';
  } else {
    return '\$${amount.toStringAsFixed(1)}';
  }
}

String formatCurrency(double amount, int decimal) {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: decimal,
  );
  return currencyFormatter.format(amount);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int currentPage = 1;
  List<CryptoRecord> cryptocurrencies = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  String dropdownValue = '24h';
  String timePeriod = 'today';

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_scrollListener);
  }

  void _fetchData() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    var newCryptoData = await getAllCryptocurrencies(currentPage);
    setState(() {
      cryptocurrencies.addAll(newCryptoData.data);
      isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      currentPage++;
      _fetchData();
    }
  }

  Future<void> _refresh() async {
    currentPage = 1;
    cryptocurrencies.clear();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0e0f18),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome username!',
                  style: Header2(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Your portfolio is', style: Header3()),
                  Text(
                    ' 7% ',
                    style: UpText(),
                  ),
                  Text(
                    'up today',
                    style: Header3(),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: SizedBox(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 4) {
                  return IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {},
                  );
                }
                return Container(
                  width: 180.0,
                  child: Card(
                    child: Center(
                      child: Text('Portfolio ${index + 1}'),
                    ),
                  ),
                );
              },
            ),
          ),
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
                  });
                },
                items: <String>['1h', '24h', '7d', '30d']
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
                    return Container(
                        padding: index == 0
                            ? const EdgeInsets.only(bottom: 4.0)
                            : index == cryptocurrencies.length - 1
                                ? const EdgeInsets.only(top: 4.0)
                                : const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16.0,
                              backgroundImage: NetworkImage(
                                "https://s2.coinmarketcap.com/static/img/coins/64x64/${record.icon}.png",
                              ),
                              backgroundColor: Colors.transparent,
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
                                    formatMoney(record.circulatingSupply *
                                        record.price),
                                    style: InputPlaceholder(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // This will make the column take up the least amount of space
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatCurrency(
                                        record.price, record.decimal),
                                    style: Body(),
                                  ),
                                  Text(
                                    '1 %',
                                    style: UpText(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Controller'ı temizle
    super.dispose();
  }
}
