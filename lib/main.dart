import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:marketsnapp/firebase_options.dart';
import 'package:marketsnapp/screens/landing_screen.dart';
import 'package:marketsnapp/screens/login_screen.dart';
import 'package:marketsnapp/screens/signup_screen.dart';
import 'package:marketsnapp/screens/loading_screen.dart';
import 'package:marketsnapp/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoadingScreen(),
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LandingScreen.id: (context) => const LandingScreen(),
        SignUpSection.id: (context) => const SignUpSection(),
        LoginSection.id: (context) => const LoginSection()
      },
    );
  }
}
