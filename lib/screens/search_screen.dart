import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marketsnapp/api/cryptocurrency.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/screens/token_detail_screen.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  List<CryptoRecord> cryptocurrencies = [];
  List<CryptoRecord> initialCryptocurrencies = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final FocusNode _focusNode = FocusNode();

  void _fetchData() async {
    if (isLoading) return;
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      var newCryptoData = await getAllCryptocurrencies(1, "1d");
      if (mounted) {
        setState(() {
          initialCryptocurrencies = newCryptoData.data;
          cryptocurrencies = List.from(initialCryptocurrencies);
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

  void _searchData(String query) async {
    if (isLoading) return;
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      var newCryptoData = await searchCryptocurrencies(query);
      if (mounted) {
        setState(() {
          cryptocurrencies = newCryptoData.data;
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

  void searchCrypto(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      _searchData(query);
    });
  }

  void _clearSearch() {
    if (mounted) {
      _searchController.clear();
      setState(() {
        cryptocurrencies = List.from(initialCryptocurrencies);
      });
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && cryptocurrencies.isEmpty) {
      if (mounted) {
        setState(() {
          cryptocurrencies = List.from(initialCryptocurrencies);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Text(
            'Search or select from the list the coin you want.',
            style: Body(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: (value) {
              searchCrypto(value);
              if (value.isEmpty) {
                setState(() {
                  cryptocurrencies = List.from(initialCryptocurrencies);
                });
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
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : ListView.builder(
                    itemCount: cryptocurrencies.length,
                    itemBuilder: (context, index) {
                      final record = cryptocurrencies[index];

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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                record.name,
                                style: Header3(),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                record.symbol,
                                style: InputPlaceholder(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        )
      ],
    );
  }
}
