import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:marketsnapp/utils/windowSizeFormatter.dart';

Future<CryptocurrencyData> getAllCryptocurrencies(
    int page, String windowSize) async {
  const String endpoint = 'cryptocurrency';

  String windowSizeParam = windowSizeFormatter(windowSize);

  Map<String, dynamic> queryParams = {
    "page": page.toString(),
    "windowSize": windowSizeParam
  };

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

Future<CryptocurrencyData> getCryptocurrency(
    String symbol, String windowSize) async {
  final String endpoint = 'cryptocurrency/$symbol';

  String windowSizeParam = windowSizeFormatter(windowSize);

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

Future<CryptocurrencyData> searchCryptocurrencies(String query) async {
  const String endpoint = 'cryptocurrency/search';

  Map<String, dynamic> queryParams = {
    "q": query,
  };

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
