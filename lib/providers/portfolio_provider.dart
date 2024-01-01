import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/providers/cryptocurrency_provider.dart';
import 'dart:convert';

import 'package:marketsnapp/types/portfolio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioProvider with ChangeNotifier {
  Portfolio? _portfolio;

  Portfolio get portfolio => _portfolio!;

  double get totalPortfolioValue {
    if (_portfolio == null) return 0;
    return _portfolio!.holdings
        .fold(0, (sum, holding) => sum + holding.currentValue);
  }

  double get totalProfit {
    if (_portfolio == null) return 0;
    return _portfolio!.holdings.fold(0, (sum, holding) => sum + holding.profit);
  }

  double get totalChange {
    if (_portfolio == null) return 0;

    double totalSpend = _portfolio!.holdings.fold(
        0,
        (sum, holding) =>
            sum + (holding.averagePurchasePrice * holding.amount));

    if (this.totalProfit > 0) {
      return ((this.totalPortfolioValue / totalSpend) - 1) * 100;
    } else {
      return (2 - (this.totalPortfolioValue / totalSpend)) * 100;
    }
  }

  Future<void> getPortfolio() async {
    const String endpoint = 'portfolio';
    String url = '$serverURL$endpoint';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(response.body);
        _portfolio = Portfolio.fromJson(data['data']);
        notifyListeners();
      } else {
        print('Failed to load portfolio');
      }
    } catch (error) {
      print(error);
    }
  }

  void updateHoldingValues(CryptocurrencyProvider cryptocurrencyProvider) {
    if (_portfolio == null) return;
    for (var holding in _portfolio!.holdings) {
      var cryptocurrency = cryptocurrencyProvider.cryptocurrencies.firstWhere(
        (c) => c.id == holding.cryptocurrencyId,
      );

      holding.calculateValues(cryptocurrency.price);
    }
    notifyListeners();
  }

  void listenToCryptocurrencyUpdates(
      CryptocurrencyProvider cryptocurrencyProvider) {
    cryptocurrencyProvider.addListener(() {
      updateHoldingValues(cryptocurrencyProvider);
    });
  }

  void sortHoldingsByCurrentValue(
      CryptocurrencyProvider cryptocurrencyProvider) {
    if (_portfolio == null) return;

    _portfolio!.holdings.sort((a, b) {
      final cryptocurrencyA = cryptocurrencyProvider.cryptocurrencies
          .firstWhere((crypto) => crypto.id == a.cryptocurrencyId);
      final cryptocurrencyB = cryptocurrencyProvider.cryptocurrencies
          .firstWhere((crypto) => crypto.id == b.cryptocurrencyId);

      double currentValueA = cryptocurrencyA.price * a.amount;
      double currentValueB = cryptocurrencyB.price * b.amount;

      return currentValueB.compareTo(currentValueA);
    });

    notifyListeners();
  }

  Map<String, double> createHoldingsPieChartData(
      CryptocurrencyProvider cryptocurrencyProvider) {
    Map<String, double> data = {};
    if (_portfolio != null) {
      for (var holding in _portfolio!.holdings) {
        String name = cryptocurrencyProvider
            .findCryptocurrency(holding.cryptocurrencyId)
            .name!;
        double currentValue = holding.currentValue;
        if (currentValue > 0) {
          if (data.containsKey(name)) {
            data[name] = (data[name]! + currentValue);
          } else {
            data[name] = currentValue;
          }
        }
      }
    }
    return data;
  }
}
