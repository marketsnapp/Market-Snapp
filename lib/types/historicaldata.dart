import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/utils/windowSizeFormatter.dart';

class PriceData {
  final DateTime openTime;
  final double closePrice;

  PriceData({required this.openTime, required this.closePrice});

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      openTime: DateTime.fromMillisecondsSinceEpoch(json['open_time'] as int),
      closePrice: double.parse(json['close_price']),
    );
  }
}

class HistoricalData {
  final bool status;
  final String message;
  final List<PriceData> priceData;

  HistoricalData({
    required this.status,
    required this.message,
    required this.priceData,
  });

  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'];
    if (dataList is! List) {
      return HistoricalData(
        status: json['status'],
        message: json['message'] ?? 'Missing message',
        priceData: [],
      );
    }

    var priceData = dataList
        .map((priceDataJson) => PriceData.fromJson(priceDataJson))
        .cast<PriceData>()
        .toList();
    return HistoricalData(
      status: json['status'],
      message: json['message'],
      priceData: priceData,
    );
  }
}

Future<HistoricalData> fetchHistoricalData(
    String currencySymbol, String windowSize) async {
  final endpoint =
      "cryptocurrency/$currencySymbol/historicalData?windowSize=${windowSizeFormatter(windowSize)}";
  final response = await http.get(Uri.parse("$serverURL$endpoint"));

  if (response.statusCode == 200) {
    return HistoricalData.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load historical data');
  }
}
