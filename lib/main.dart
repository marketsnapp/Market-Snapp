import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:marketsnapp/firebase_options.dart';
import 'package:marketsnapp/screens/landing_screen.dart';
import 'package:marketsnapp/screens/login_screen.dart';
import 'package:marketsnapp/screens/signup_screen.dart';
import 'package:marketsnapp/screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.getToken().then((value) {
    print("get token: $value");
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const loadingScreen(),
      routes: {
        SignUpSection.id: (context) => SignUpSection(),
        LandingScreen.id: (context) => const LandingScreen(),
        LoginSection.id: (context) => LoginSection()
      },
    );
  }
}
