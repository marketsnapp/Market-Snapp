import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/cryptocurrencies.dart';

Future<CryptocurrencyData> getAllCryptocurrencies(int page) async {
  const String endpoint = 'cryptocurrencies';

  // Define your parameters as a map
  Map<String, dynamic> queryParams = {"page": page.toString()};

  // Convert the map to query parameters
  final String queryString = Uri(queryParameters: queryParams).query;

  final String url =
      page > 1 ? '$serverURL$endpoint?$queryString' : '$serverURL$endpoint';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parse the JSON response and convert it to a CryptocurrencyData object
      final data = CryptocurrencyData.fromJson(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load cryptocurrency data');
    }
  } catch (error) {
    throw error;
  }
}
