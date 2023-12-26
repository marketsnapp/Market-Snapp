import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const serverURL = "http://192.168.0.102:5000/";
// Renk ve Stil Sabitleri
const whiteColor = Colors.white;
const headlineFontSize = 18.0;
const bodyTextFontSize = 18.0;
final whiteColorOpacity55 = Colors.white.withOpacity(0.55);
const greenColor = Color(0xff0dc471);
const redColor = Color(0xfffc3044);
const primaryColor = Color(0xff0057ff);
const backgroundColor = Color(0xff0e0f18);

TextStyle spaceGroteskStyle(double size, FontWeight weight, Color color) {
  return GoogleFonts.spaceGrotesk(
      fontSize: size, fontWeight: weight, color: color);
}

TextStyle Header1() {
  return spaceGroteskStyle(32, FontWeight.w700, whiteColor);
}

TextStyle Header2() {
  return spaceGroteskStyle(24, FontWeight.w600, whiteColor);
}

TextStyle Header3() {
  return spaceGroteskStyle(18, FontWeight.w600, whiteColor);
}

TextStyle Body() {
  return spaceGroteskStyle(16, FontWeight.w400, whiteColor);
}

TextStyle InputPlaceholder() {
  return spaceGroteskStyle(16, FontWeight.w400, whiteColorOpacity55);
}

TextStyle BodyLink() {
  return spaceGroteskStyle(16, FontWeight.w400, primaryColor);
}

TextStyle UpText() {
  return spaceGroteskStyle(16, FontWeight.w400, greenColor);
}

TextStyle DownText() {
  return spaceGroteskStyle(16, FontWeight.w400, redColor);
}
