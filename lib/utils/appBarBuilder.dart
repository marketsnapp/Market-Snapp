import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/screens/alerts_screen.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/portfolio_screen.dart';
import 'package:marketsnapp/screens/search_screen.dart';
import 'package:marketsnapp/screens/settings_screen.dart';

AppBar appBarBuilder(BuildContext context, String id) {
  Widget appBarTitle;

  switch (id) {
    case HomeScreen.id:
      appBarTitle = Text('Market Snapp', style: Header1());
      break;
    case PortfolioScreen.id:
      appBarTitle = Text('Portfolio', style: Header1());
      break;
    case SearchScreen.id:
      appBarTitle = Text('Search', style: Header1());
      return AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8.0,
        title: appBarTitle,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        actions: [
          InkWell(
            child: const Icon(
              Icons.close,
              color: whiteColor,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    case AlertsScreen.id:
      appBarTitle = Text('Alerts', style: Header1());
      break;
    case SettingsScreen.id:
      appBarTitle = Text('Settings', style: Header1());
      break;
    default:
      appBarTitle = const Text("");
  }

  return AppBar(
    titleSpacing: 8.0,
    title: appBarTitle,
    scrolledUnderElevation: 0,
    backgroundColor: backgroundColor,
  );
}
