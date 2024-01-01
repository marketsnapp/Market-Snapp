import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/providers/user_provider.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginSection extends StatefulWidget {
  static const String id = 'login';
  const LoginSection({super.key});

  @override
  _LoginSectionState createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  String email = '';
  String password = '';
  String? errorMessage;

  Future<void> attemptLogin() async {
    setState(() {
      errorMessage = null;
    });

    String resultMessage =
        await Provider.of<UserProvider>(context, listen: false)
            .login(email, password);

    if (mounted) {
      if (Provider.of<UserProvider>(context, listen: false).user != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          errorMessage = resultMessage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Login", style: Header1()),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  hintStyle: InputPlaceholder(),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColorOpacity55),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColorOpacity55),
                  ),
                  fillColor: Colors.transparent,
                ),
                style: Body(),
                cursorColor: primaryColor,
                cursorHeight: 20,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: InputPlaceholder(),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColorOpacity55),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColorOpacity55),
                  ),
                  fillColor: Colors.transparent,
                ),
                style: Body(),
                cursorColor: primaryColor,
                cursorHeight: 20,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  errorMessage!,
                  style: DownText(),
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    visualDensity: const VisualDensity(),
                    backgroundColor: primaryColor,
                    disabledBackgroundColor:
                        const Color.fromARGB(64, 0, 85, 255),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: email.isNotEmpty && password.isNotEmpty
                      ? () => attemptLogin()
                      : null,
                  child: Text(
                    "Login",
                    style: Body(),
                  )),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "Don't have an account?",
                    style: Body(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUpSection.id);
                    },
                    child: Text(
                      'Sign Up',
                      style: BodyLink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
