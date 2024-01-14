import 'package:flutter/material.dart';
import 'package:marketsnapp/providers/user_provider.dart';
import 'package:marketsnapp/utils/appBarBuilder.dart';
import 'package:marketsnapp/utils/bottomNavigationBarBuilder.dart';
import 'package:marketsnapp/widgets/home_screen_cryptocurrency_market_widget.dart';
import 'package:marketsnapp/widgets/home_screen_portfolio_widget.dart';
import 'package:provider/provider.dart';
import 'package:marketsnapp/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBarBuilder(context, HomeScreen.id),
      bottomNavigationBar: bottomNavigationBarBuilder(context, HomeScreen.id),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome ${Provider.of<UserProvider>(context).user!.email}!',
                  style: Header2(),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              const HomeScreenPortfolioWidget(),
              const SizedBox(
                height: 4.0,
              ),
              const Expanded(
                child: HomeScreenMarketWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
