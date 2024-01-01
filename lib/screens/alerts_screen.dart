import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  static const String id = 'alert';

  @override
  State<AlertsScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.alarm);
  }
}
