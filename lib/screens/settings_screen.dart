import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/providers/user_provider.dart';
import 'package:marketsnapp/screens/login_screen.dart';
import 'package:marketsnapp/utils/appBarBuilder.dart';
import 'package:marketsnapp/utils/bottomNavigationBarBuilder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String id = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(context, id),
      bottomNavigationBar: bottomNavigationBarBuilder(context, id),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              Provider.of<UserProvider>(context).user!.email,
              style: spaceGroteskStyle(20, FontWeight.w700, whiteColor),
            ),
            ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.pushReplacementNamed(context, LoginSection.id);
              },
              tileColor: backgroundColor,
              title: Text(
                'Log Out',
                style: spaceGroteskStyle(16, FontWeight.w400, whiteColor),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Socials",
              style: spaceGroteskStyle(20, FontWeight.w700, whiteColor),
            ),
            ListTile(
              onTap: () {
                print('Twitter is clicked');
              },
              tileColor: backgroundColor,
              title: Text(
                'Twitter',
                style: spaceGroteskStyle(16, FontWeight.w400, whiteColor),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                print('Telegram is clicked');
              },
              tileColor: backgroundColor,
              title: Text(
                'Telegram',
                style: spaceGroteskStyle(16, FontWeight.w400, whiteColor),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                print('Medium is clicked');
              },
              tileColor: backgroundColor,
              title: Text(
                'Medium',
                style: spaceGroteskStyle(16, FontWeight.w400, whiteColor),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                print('Share This App is clicked');
              },
              tileColor: backgroundColor,
              title: Text(
                'Share This App',
                style: spaceGroteskStyle(16, FontWeight.w400, whiteColor),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
