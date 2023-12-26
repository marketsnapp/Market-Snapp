import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketsnapp/api/auth.dart';
import 'package:marketsnapp/screens/profile_screen.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/add_transaction_search_screen.dart';
import 'package:marketsnapp/screens/settings_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  static const String id = 'landing';
  @override
  State<LandingScreen> createState() => _LandingScreen();
}

class _LandingScreen extends State<LandingScreen> {
  int _selectedIndex = 0;

  AppBar _buildAppBar(BuildContext context, int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: Text(
            'Market Snapp',
            style: Header1(),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: backgroundColor,
        );
      case 1:
        return AppBar();
      default:
        return AppBar();
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    profileScreen(),
    addTransactionSearchScreen(),
    Icon(Icons.home),
    SettingsBody(),
  ];

  void _onItemTapped(int index) async {
    if (index == 1) {
      await getUser();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      profileScreen.email = prefs.getString("email");
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, _selectedIndex),
      backgroundColor: backgroundColor,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: backgroundColor,
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: backgroundColor,
            label: 'Menu',
            icon: Icon(Icons.description),
          ),
          BottomNavigationBarItem(
            backgroundColor: backgroundColor,
            label: 'Add',
            icon: Icon(
              Icons.add_circle,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: backgroundColor,
            label: 'Notifications',
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            backgroundColor: backgroundColor,
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
