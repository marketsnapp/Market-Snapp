import 'package:flutter/material.dart';
import 'add_transaction_search_screen.dart';

class addTransactionPage extends StatefulWidget {
  final Crypto cryptoData;
  const addTransactionPage({Key? key, required this.cryptoData})
      : super(key: key);

  @override
  State<addTransactionPage> createState() => _addTransactionPageState();
}

class _addTransactionPageState extends State<addTransactionPage> {
  bool deduct = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xff0e0f18),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white70, // <-- SEE HERE
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff0e0f18),
          title: Text(
            '${widget.cryptoData.name}',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: const Color.fromRGBO(50, 204, 134, 1.0),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 18),
            labelColor: Colors.white, //<-- selected text color
            unselectedLabelColor: Colors.white70, //<-- Unselected text color
            tabs: <Widget>[
              Tab(
                text: 'Buy',
              ),
              Tab(
                text: 'Sell',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListView(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    print('Price is clicked');
                  },
                  tileColor: const Color(0xff0e0f18),
                  subtitle: const Text(
                    'Enter the price when you bought',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () {
                    print('Amount bought is clicked');
                  },
                  tileColor: const Color(0xff0e0f18),
                  subtitle: const Text(
                    'Enter the amount you bought',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Amount bought',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () {
                    print('Amount bought is clicked');
                  },
                  tileColor: const Color(0xff0e0f18),
                  title: const Text(
                    'Deduct from ETH holdings?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Switch(
                    inactiveTrackColor: const Color(0xff0e0f18),
                    activeColor: const Color.fromRGBO(50, 204, 134, 1.0),
                    value: deduct,
                    onChanged: (value) {
                      setState(() {
                        deduct = value;
                        print('Deduct is ${deduct}');
                      });
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
        bottomNavigationBar: Material(
          color: const Color.fromRGBO(50, 204, 134, 1.0),
          child: InkWell(
            onTap: () {
              print('called on tap');
            },
            child: const SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Add transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
