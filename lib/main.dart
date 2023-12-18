import 'package:flutter/material.dart';
import 'package:marketsnapp/pages/HomePage.dart';
import 'package:marketsnapp/pages/LoginPage.dart';
import 'package:marketsnapp/pages/SignUpPage.dart';
import 'package:marketsnapp/pages/WelcomePage.dart';
import 'package:marketsnapp/pages/SplashPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/welcome': (_) => const WelcomePage(),
        '/login': (_) => const LoginPage(),
        '/sign-up': (_) => const SignUpPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
