import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> signup(var email, var password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = 'http://192.168.0.102:5000/auth/sign-up';
  String? registerationToken = await FirebaseMessaging.instance.getToken();
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'registration_token': registerationToken!,
    }),
  );
  print(response.body);
  var parse = jsonDecode(response.body);
  await prefs.setString('token', parse["token"]);
}

Future<void> login(var email, var password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = 'http://192.168.0.102:5000/auth/login';
  String? registerationToken = await FirebaseMessaging.instance.getToken();
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'registration_token': registerationToken!,
    }),
  );
  var parse = jsonDecode(response.body);
  print(response.body);
  await prefs.setString('token', parse["token"]);
}

Future<void> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  print(token);
  String url = 'http://192.168.0.102:5000/auth/user';
  final response = await http.get(
    Uri.parse(url),
    headers: {"token": token ?? token.toString()},
  );
  print(response.body);
  final result = jsonDecode(response.body) as Map<String, dynamic>;
  await prefs.setString('email', result['email']);
}
