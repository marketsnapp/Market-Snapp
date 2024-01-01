import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/providers/cryptocurrency_provider.dart';
import 'package:marketsnapp/screens/token_detail_screen.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/utils/appBarBuilder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String id = 'search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<CryptocurrencyRecord> cryptocurrencies = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    cryptocurrencies =
        Provider.of<CryptocurrencyProvider>(context, listen: false)
            .getPaginatedCryptocurrencies(1);

    _focusNode.addListener(_onFocusChange);
  }

  void searchCrypto(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      var newCryptoData =
          context.read<CryptocurrencyProvider>().searchCryptocurrencies(query);
      setState(() {
        cryptocurrencies = newCryptoData;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    searchCrypto('');
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _searchController.text.isEmpty) {
      searchCrypto('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBarBuilder(context, SearchScreen.id),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search or select from the list the coin you want.',
              style: Body(),
            ),
            const SizedBox(
              height: 4,
            ),
            TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    cryptocurrencies = Provider.of<CryptocurrencyProvider>(
                      context,
                      listen: false,
                    ).getPaginatedCryptocurrencies(1);
                  });
                } else {
                  searchCrypto(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: InputPlaceholder(),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColorOpacity55),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColorOpacity55),
                ),
                fillColor: Colors.transparent,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              style: Body(),
              cursorColor: primaryColor,
              cursorHeight: 20,
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cryptocurrencies.length,
                itemBuilder: (context, index) {
                  final cryptocurrency = cryptocurrencies[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TokenDetailScreen(
                            cryptocurrency: cryptocurrency,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(
                              "https://s2.coinmarketcap.com/static/img/coins/64x64/${cryptocurrency.icon}.png",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            cryptocurrency.name!,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
