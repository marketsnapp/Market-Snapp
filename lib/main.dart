import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:marketsnapp/firebase_options.dart';
import 'package:marketsnapp/providers/cryptocurrency_provider.dart';
import 'package:marketsnapp/providers/portfolio_provider.dart';
import 'package:marketsnapp/providers/user_provider.dart';
import 'package:marketsnapp/screens/alerts_screen.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/login_screen.dart';
import 'package:marketsnapp/screens/portfolio_screen.dart';
import 'package:marketsnapp/screens/search_screen.dart';
import 'package:marketsnapp/screens/settings_screen.dart';
import 'package:marketsnapp/screens/signup_screen.dart';
import 'package:marketsnapp/screens/loading_screen.dart';
import 'package:marketsnapp/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CryptocurrencyProvider()),
        ChangeNotifierProvider(create: (context) => PortfolioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
        SignUpSection.id: (context) => const SignUpSection(),
        LoginSection.id: (context) => const LoginSection(),
        HomeScreen.id: (context) => const HomeScreen(),
        PortfolioScreen.id: (context) => PortfolioScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        AlertsScreen.id: (context) => const AlertsScreen(),
        SettingsScreen.id: (context) => const SettingsScreen(),
      },
    );
  }
}
