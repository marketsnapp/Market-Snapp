import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/types/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    int userId = decodedToken['userId'];
    String email = decodedToken['email'];

    _user = User(userId: userId, email: email);

    notifyListeners();
  }

  Future<String> signup(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const String endpoint = 'auth/sign-up';

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

      var parse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await prefs.setString('token', parse["token"]);
        setUser(parse["token"]);
      }

      return parse["message"];
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> login(String email, String password) async {
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

      var parse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await prefs.setString('token', parse["token"]);
        setUser(parse["token"]);
      }

      return parse["message"];
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> checkUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return false;
    }

    if (JwtDecoder.isExpired(token)) {
      return false;
    }

    const String endpoint = 'auth/user';

    var response = await http.get(
      Uri.parse('$serverURL$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setUser(token);
      return true;
    }

    return false;
  }
}
