import 'package:flutter/material.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Card(
            color: const Color(0xff0e0f18),
            child: Column(
              children: [
                const ListTile(
                  tileColor: const Color(0xff0e0f18),
                  title: Text(
                    'Accounts',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    print('User Profile is clicked');
                  },
                  tileColor: const Color(0xff0e0f18),
                  title: const Text(
                    'User Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () {
                    print('Log Out is clicked');
                  },
                  tileColor: const Color(0xff0e0f18),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                const ListTile(
                  tileColor: const Color(0xff0e0f18),
                  title: Text(
                    'Socials',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    print('Twitter is clicked');
                  },
                  tileColor: const Color(0xff0e0f18),
                  title: const Text(
                    'Twitter',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
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
                  tileColor: const Color(0xff0e0f18),
                  title: const Text(
                    'Telegram',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
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
                  tileColor: const Color(0xff0e0f18),
                  title: const Text(
                    'Medium',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
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
                  tileColor: const Color(0xff0e0f18),
                  title: const Text(
                    'Share This App',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
