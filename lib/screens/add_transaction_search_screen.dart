import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';

class Crypto {
  final String name;
  final String abbreviation;
  final String image;

  String get gname => name;

  Crypto(this.name, this.abbreviation, this.image);
}

List<Crypto> allcryptos = [
  Crypto('BitCoin', '(BTC)',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Bitcoin.svg/150px-Bitcoin.svg.png'),
  Crypto('Ethereum', '(ETH)',
      'https://avatars.githubusercontent.com/u/6250754?s=200&v=4'),
];

class addTransactionSearchScreen extends StatefulWidget {
  const addTransactionSearchScreen({super.key});

  @override
  State<addTransactionSearchScreen> createState() =>
      _addTransactionSearchScreenState();
}

class _addTransactionSearchScreenState
    extends State<addTransactionSearchScreen> {
  List<Crypto> cryptos = allcryptos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '   Search or select from the list the coin you want.',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 38,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: searchCrypto,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(fontSize: 25, color: Colors.grey.shade500),
                hintText: 'Search Crypto'),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cryptos.length,
            itemBuilder: (context, index) {
              final crypto = cryptos[index];

              return ListTile(
                leading: Image.network(
                  crypto.image,
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  crypto.name,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addTransactionPage(
                              cryptoData: crypto,
                            ))),
              );
            },
          ),
        )
      ],
    );
  }

  void searchCrypto(String query) {
    final suggestions = allcryptos.where((crypto) {
      final cryptoName = crypto.name.toLowerCase();
      final input = query.toLowerCase();

      return cryptoName.contains(input);
    }).toList();

    setState(() => cryptos = suggestions);
  }
}
