import 'package:flutter/material.dart';
import 'package:marketsnapp/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketsnapp/screens/landing_screen.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    checkToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (token != null) {
        Navigator.pushReplacementNamed(context, LandingScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, SplashScreen.id);
      }
    }

    checkToken();
    return const Scaffold();
  }
}
