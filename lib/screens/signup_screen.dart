import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/api/auth.dart';
import 'package:marketsnapp/screens/landing_screen.dart';
import 'package:marketsnapp/screens/login_screen.dart';

class SignUpSection extends StatefulWidget {
  static const String id = 'sign-up';
  const SignUpSection({super.key});

  @override
  _SignUpSectionState createState() => _SignUpSectionState();
}

class _SignUpSectionState extends State<SignUpSection> {
  String email = '';
  String password = '';
  String? errorMessage;

  Future<void> attemptSignup() async {
    setState(() {
      errorMessage = null;
    });
    String? result = await signup(email, password);
    if (result != null) {
      setState(() {
        errorMessage = result;
      });
    } else {
      Navigator.pushReplacementNamed(context, LandingScreen.id);
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
                child: Text("Let’s create your account", style: Header1()),
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
                    visualDensity: VisualDensity(),
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
                      ? () => attemptSignup()
                      : null,
                  child: Text(
                    "Sign Up",
                    style: Body(),
                  )),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: Body(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(LoginSection.id);
                    },
                    child: Text(
                      'Login',
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
