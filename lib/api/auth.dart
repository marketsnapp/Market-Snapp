import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:marketsnapp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> signup(var email, var password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  const String endpoint = 'auth/sign-up';

  String url = '$serverURL$endpoint';
  String? registerationToken = await FirebaseMessaging.instance.getToken();

  try {
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

    if (response.statusCode == 201) {
      var parse = jsonDecode(response.body);
      await prefs.setString('token', parse["token"]);
      return null;
    } else {
      var parse = jsonDecode(response.body);
      return parse["message"];
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String?> login(String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  const String endpoint = 'auth/login';
  String url = '$serverURL$endpoint';
  String? registerationToken = await FirebaseMessaging.instance.getToken();

  if (registerationToken == null) {
    return "Registration token not found";
  }

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'registration_token': registerationToken,
      }),
    );

    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      await prefs.setString('token', parse["token"]);
      return null;
    } else if (response.statusCode == 400) {
      var parse = jsonDecode(response.body);
      return "Error: ${parse["error"]}";
    } else {
      return "An unexpected error occurred during login";
    }
  } catch (e) {
    return "An error occurred: ${e.toString()}";
  }
}

Future<void> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  const String endpoint = 'auth/user';

  String url = '$serverURL$endpoint';
  String? token = prefs.getString("token");
  final response = await http.get(
    Uri.parse(url),
    headers: {"token": token ?? token.toString()},
  );
  final result = jsonDecode(response.body) as Map<String, dynamic>;
  await prefs.setString('email', result['email']);
}
