import 'package:flutter/material.dart';
import 'package:marketsnapp/providers/cryptocurrency_provider.dart';
import 'package:marketsnapp/providers/portfolio_provider.dart';
import 'package:marketsnapp/providers/user_provider.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  static String id = "/";

  @override
  Widget build(BuildContext context) {
    Future<void> checkUserToken() async {
      bool isAuthenticated =
          await Provider.of<UserProvider>(context, listen: false)
              .checkUserToken();

      if (isAuthenticated) {
        CryptocurrencyProvider cryptocurrencyProvider =
            Provider.of<CryptocurrencyProvider>(context, listen: false);

        PortfolioProvider portfolioProvider =
            Provider.of<PortfolioProvider>(context, listen: false);

        await cryptocurrencyProvider.fetchCryptocurrencies("24 Hours");

        await portfolioProvider.getPortfolio();

        portfolioProvider.listenToCryptocurrencyUpdates(cryptocurrencyProvider);

        portfolioProvider.sortHoldingsByCurrentValue(cryptocurrencyProvider);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserToken();
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
