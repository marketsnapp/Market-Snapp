import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketsnapp/api/auth.dart';
import 'package:marketsnapp/screens/profile_screen.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'add_transaction_search_screen.dart';
import 'settings_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  static const String id = 'LandingPage';
  @override
  State<LandingScreen> createState() => _LandingScreen();
}

class _LandingScreen extends State<LandingScreen> {
  int _selectedIndex = 0;

  List<AppBar> appbar = [
    //Home Appbar
    AppBar(
      title: const Text(
        '1',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromRGBO(14, 15, 24, 1.0),
    ),
    // Description App Bar
    AppBar(
      title: Text(
        '2',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromRGBO(14, 15, 24, 1.0),
    ),
    // Add Appbar
    AppBar(
      centerTitle: true,
      title: const Text(
        'Add Transaction',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color.fromRGBO(14, 15, 24, 1.0),
    ),
    // Notifications Bar
    AppBar(
      centerTitle: true,
      title: const Text(
        'Notifications',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color.fromRGBO(14, 15, 24, 1.0),
    ),
    //Settings Appbar
    AppBar(
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ))
      ],
      title: const Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color.fromRGBO(14, 15, 24, 1.0),
    ),
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    homeScreen(),
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
      appBar: appbar[_selectedIndex],
      backgroundColor: Colors.black,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(14, 15, 24, 1.0),
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(14, 15, 24, 1.0),
            label: 'Menu',
            icon: Icon(Icons.description),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(14, 15, 24, 1.0),
            label: 'Add',
            icon: Icon(Icons.add_circle),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(14, 15, 24, 1.0),
            label: 'Notifications',
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(14, 15, 24, 1.0),
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
