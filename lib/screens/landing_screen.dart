import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketsnapp/api/auth.dart';
import 'package:marketsnapp/screens/profile_screen.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/search_screen.dart';
import 'package:marketsnapp/screens/settings_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  static const String id = 'landing';

  @override
  State<LandingScreen> createState() => _LandingScreen();
}

class _LandingScreen extends State<LandingScreen> {
  String _selectedID = 'home';

  AppBar _buildAppBar(BuildContext context, String id) {
    Widget appBarTitle;

    switch (id) {
      case 'home':
        appBarTitle = Text('Market Snapp', style: Header1());
        break;
      case 'menu':
        appBarTitle = Text('Portfolio', style: Header1());
        break;
      case 'search':
        appBarTitle = Text('Search', style: Header1());
        return AppBar(
          titleSpacing: 8.0,
          title: appBarTitle,
          scrolledUnderElevation: 0,
          backgroundColor: backgroundColor,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: whiteColor,
              ),
              onPressed: () => setState(() {
                _selectedID = "home";
              }),
            ),
          ],
        );
      case 'alerts':
        appBarTitle = Text('Alerts', style: Header1());
        break;
      case 'settings':
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

  static final Map<String, Widget> _widgetOptions = {
    'home': const HomeScreen(),
    'menu': profileScreen(),
    "search": SearchScreen(),
    "alerts": const Icon(Icons.home),
    "settings": const SettingsBody(),
    // Diğer widget'lar buraya eklenecek
  };

  void _onItemTapped(String id) {
    setState(() {
      _selectedID = id;
    });
  }

  BottomNavigationBar? _buildBottomNavigationBar(
      BuildContext context, String id) {
    final bottomNavigationBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      backgroundColor: backgroundColor,
      unselectedItemColor: whiteColor,
      unselectedLabelStyle: Body(),
      showUnselectedLabels: false,
      selectedLabelStyle: Body(),
      currentIndex: _widgetOptions.keys.toList().indexOf(_selectedID),
      onTap: (index) => _onItemTapped(_widgetOptions.keys.toList()[index]),
      items: const <BottomNavigationBarItem>[
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
    switch (id) {
      case 'search':
        return null;
      default:
        return bottomNavigationBar;
    }
  }

  void _initializeMenu() async {
    await getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profileScreen.email = prefs.getString("email");
  }

  @override
  void initState() {
    super.initState();
    _initializeMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, _selectedID),
      backgroundColor: backgroundColor,
      body: _widgetOptions[_selectedID],
      bottomNavigationBar: _buildBottomNavigationBar(context, _selectedID),
    );
  }
}
