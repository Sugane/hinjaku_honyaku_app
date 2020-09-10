import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  Light,
  Dark,
}

final themeData = {
  AppTheme.Light: ThemeData(
    primaryColor: Color.fromRGBO(109, 21, 155, 1),
    accentColor: Color.fromRGBO(255, 168, 0, 1),
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Color(0xFFF3F5F7),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.black,
        fontFamily: 'Lato',
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontFamily: 'Lato',
      ),
    ),
  ),
  AppTheme.Dark: ThemeData(
    primaryColor: Color.fromRGBO(109, 21, 155, 1),
    accentColor: Color.fromRGBO(255, 168, 0, 1),
    backgroundColor: Color.fromRGBO(36, 37, 38, 1),
    scaffoldBackgroundColor: Color.fromRGBO(24, 25, 26, 1),
    textTheme: GoogleFonts.josefinSansTextTheme().copyWith(
      bodyText1: TextStyle(
        color: Colors.white70,
        fontFamily: 'Lato',
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontFamily: 'Lato',
      ),
    ),
  )
};
