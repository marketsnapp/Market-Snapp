import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/screens/alerts_screen.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/portfolio_screen.dart';
import 'package:marketsnapp/screens/search_screen.dart';
import 'package:marketsnapp/screens/settings_screen.dart';

BottomNavigationBar bottomNavigationBarBuilder(
    BuildContext context, String id) {
  const routeListOrdered = [
    HomeScreen.id,
    PortfolioScreen.id,
    SearchScreen.id,
    AlertsScreen.id,
    SettingsScreen.id,
  ];

  final bottomNavigationBar = BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: primaryColor,
    backgroundColor: backgroundColor,
    unselectedItemColor: whiteColor,
    unselectedLabelStyle: Body(),
    showUnselectedLabels: false,
    selectedLabelStyle: Body(),
    currentIndex: routeListOrdered.indexWhere((element) => element == id),
    onTap: (index) {
      final route = routeListOrdered[index];
      if (route != id) {
        if (route == SearchScreen.id) {
          Navigator.pushNamed(context, route);
        } else {
          Navigator.pushReplacementNamed(context, route);
        }
      }
    },
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        backgroundColor: backgroundColor,
        label: 'Home',
        icon: Icon(Icons.home),
      ),
      BottomNavigationBarItem(
        backgroundColor: backgroundColor,
        label: 'Portfolio',
        icon: Icon(Icons.description),
      ),
      BottomNavigationBarItem(
        backgroundColor: backgroundColor,
        label: 'Search',
        icon: Icon(
          Icons.search_sharp,
        ),
      ),
      BottomNavigationBarItem(
        backgroundColor: backgroundColor,
        label: 'Alerts',
        icon: Icon(Icons.notifications_none),
      ),
      BottomNavigationBarItem(
        backgroundColor: backgroundColor,
        label: 'Settings',
        icon: Icon(Icons.settings),
      ),
    ],
  );

  return bottomNavigationBar;
}
