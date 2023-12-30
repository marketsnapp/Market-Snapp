import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/screens/login_screen.dart';
import 'package:marketsnapp/screens/signup_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String id = 'welcome';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 64,
              backgroundColor: imagePaddingBackgroundColor,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Welcome to MarketSnapp",
                style: Header1(),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "All your crypto transactions in one place! Track coins, add portfolios, buy & sell.",
                style: Body(),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  fixedSize: const Size(187, 50),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginSection.id);
                },
                child: Text(
                  "Login",
                  style: Body(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  fixedSize: const Size(187, 50),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(SignUpSection.id);
                },
                child: Text(
                  "Sign Up",
                  style: Body(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
