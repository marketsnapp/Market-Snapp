import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/utils/windowSizeFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CryptocurrencyProvider with ChangeNotifier {
  bool isLoading = false;
  List<CryptocurrencyRecord> cryptocurrencies = [];
  List<int> watchListedCryptocurrencyIDList = [];

  PriceChangeData createNewPriceChange() {
    return PriceChangeData(priceChange: 0, priceChangePercent: 0);
  }

  void updatePriceChange(CryptocurrencyRecord currentCrypto,
      CryptocurrencyRecord newCrypto, String windowSize) {
    switch (windowSize) {
      case "1h":
        currentCrypto.priceChange1h =
            newCrypto.priceChange1h ?? createNewPriceChange();
        break;
      case "1d":
        currentCrypto.priceChange1d =
            newCrypto.priceChange1d ?? createNewPriceChange();
        break;
      case "7d":
        currentCrypto.priceChange7d =
            newCrypto.priceChange7d ?? createNewPriceChange();
        break;
      default:
    }
  }

  Future<void> fetchCryptocurrencies(String windowSize) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    String windowSizeParam = windowSizeFormatter(windowSize);

    try {
      var cryptoData = await getAllCryptocurrencies(windowSizeParam);

      for (var newCrypto in cryptoData.data) {
        int index =
            cryptocurrencies.indexWhere((c) => c.symbol == newCrypto.symbol);
        if (index != -1) {
          updatePriceChange(
            cryptocurrencies[index],
            newCrypto,
            windowSizeParam,
          );
          cryptocurrencies[index].price = newCrypto.price;
          cryptocurrencies[index].marketCap = newCrypto.marketCap;
        } else {
          cryptocurrencies.add(newCrypto);
        }
      }

      cryptocurrencies.sort((a, b) => (b.marketCap - a.marketCap).toInt());
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<CryptocurrencyData> getAllCryptocurrencies(
      String windowSizeParam) async {
    const String endpoint = 'cryptocurrency';

    Map<String, dynamic> queryParams = {"windowSize": windowSizeParam};

    final String queryString = Uri(queryParameters: queryParams).query;

    final String url = '$serverURL$endpoint?$queryString';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = CryptocurrencyData.fromJson(json.decode(response.body));

        return data;
      } else {
        throw Exception('Failed to load cryptocurrency data');
      }
    } catch (error) {
      throw error;
    }
  }

  List<CryptocurrencyRecord> getPaginatedCryptocurrencies(int page) {
    int perPage = 50;
    int endIndex = (page) * perPage;

    endIndex =
        endIndex > cryptocurrencies.length ? cryptocurrencies.length : endIndex;

    return cryptocurrencies.sublist(0, endIndex);
  }

  void updateCryptocurrencyFromSocket(marketData, windowSizeParam) {
    for (var newCrypto in marketData) {
      final newCryptoObject = CryptocurrencyRecord.fromJson(newCrypto);
      int index = cryptocurrencies
          .indexWhere((c) => c.symbol == newCryptoObject.symbol);
      if (index != -1) {
        updatePriceChange(
          cryptocurrencies[index],
          newCryptoObject,
          windowSizeParam,
        );
        cryptocurrencies[index].price = newCryptoObject.price;
        cryptocurrencies[index].marketCap = newCryptoObject.marketCap;
        cryptocurrencies[index].isLastPriceUp = newCryptoObject.isLastPriceUp;
      }
    }

    cryptocurrencies.sort((a, b) => (b.marketCap - a.marketCap).toInt());
    notifyListeners();
  }

  Future<void> fetchWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    List<int> temporaryWatchlist = [];

    if (token == null) {
      return;
    }

    const String endpoint = 'watchlist';

    try {
      final response = await http.get(
        Uri.parse('$serverURL$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      var parse = jsonDecode(response.body);

      for (var data in parse["data"]) {
        temporaryWatchlist.add(data["cryptocurrency_id"]);
      }

      watchListedCryptocurrencyIDList =
          sortWatchlistByMarketCap(temporaryWatchlist);
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<CryptocurrencyRecord> searchCryptocurrencies(String query) {
    if (query.isEmpty) {
      return getPaginatedCryptocurrencies(1);
    }

    return cryptocurrencies.where((crypto) {
      return crypto.symbol.toLowerCase().contains(query.toLowerCase()) ||
          crypto.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> addWatchlist(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    const String endpoint = 'watchlist/add';

    const String url = '$serverURL$endpoint';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, int>{
        'cryptocurrency_id': id,
      }),
    );
    if (response.statusCode == 201) {
      if (!watchListedCryptocurrencyIDList.contains(id)) {
        watchListedCryptocurrencyIDList.add(id);

        watchListedCryptocurrencyIDList =
            sortWatchlistByMarketCap(watchListedCryptocurrencyIDList);
        notifyListeners();
      }
    }

    return;
  }

  Future<void> removeWatchlist(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    const String endpoint = 'watchlist/remove';

    const String url = '$serverURL$endpoint';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, int>{
        'cryptocurrency_id': id,
      }),
    );

    if (response.statusCode == 200) {
      if (watchListedCryptocurrencyIDList.contains(id)) {
        watchListedCryptocurrencyIDList.remove(id);

        watchListedCryptocurrencyIDList =
            sortWatchlistByMarketCap(watchListedCryptocurrencyIDList);
        notifyListeners();
      }
    }

    return;
  }

  bool isCryptocurrencyWatchlisted(int id) {
    return watchListedCryptocurrencyIDList.contains(id);
  }

  CryptocurrencyRecord findCryptocurrency(int id) {
    return cryptocurrencies.firstWhere((element) => element.id == id);
  }

  Future<void> fetchCryptocurrency(String symbol, String windowSize) async {
    String windowSizeParam = windowSizeFormatter(windowSize);

    try {
      var cryptoData = await getCryptocurrency(symbol, windowSizeParam);

      for (var newCrypto in cryptoData.data) {
        int index =
            cryptocurrencies.indexWhere((c) => c.symbol == newCrypto.symbol);
        if (index != -1) {
          updatePriceChange(
            cryptocurrencies[index],
            newCrypto,
            windowSizeParam,
          );
          cryptocurrencies[index].price = newCrypto.price;
          cryptocurrencies[index].marketCap = newCrypto.marketCap;
          cryptocurrencies[index].circulatingSupply =
              newCrypto.circulatingSupply;
          cryptocurrencies[index].totalSupply = newCrypto.totalSupply;
          cryptocurrencies[index].maxSupply = newCrypto.maxSupply;
        } else {
          cryptocurrencies.add(newCrypto);
        }
      }

      notifyListeners();
    } catch (e) {}
  }

  Future<CryptocurrencyData> getCryptocurrency(
    String symbol,
    String windowSizeParam,
  ) async {
    final String endpoint = 'cryptocurrency/$symbol';

    Map<String, dynamic> queryParams = {"windowSize": windowSizeParam};

    final String queryString = Uri(queryParameters: queryParams).query;

    final String url = '$serverURL$endpoint?$queryString';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = CryptocurrencyData.fromJson(json.decode(response.body));

        return data;
      } else {
        throw Exception('Failed to load cryptocurrency data');
      }
    } catch (error) {
      throw error;
    }
  }

  List<int> sortWatchlistByMarketCap(
      List<int> watchListedCryptocurrencyIDList) {
    List<CryptocurrencyRecord> watchlistedCryptocurrencies =
        watchListedCryptocurrencyIDList
            .map((id) =>
                cryptocurrencies.firstWhere((crypto) => crypto.id == id))
            .toList();

    watchlistedCryptocurrencies
        .sort((a, b) => b.marketCap.compareTo(a.marketCap));

    return watchlistedCryptocurrencies.map((crypto) => crypto.id).toList();
  }
}
