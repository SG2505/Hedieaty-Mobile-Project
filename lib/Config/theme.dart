import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData theme = ThemeData(
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontFamily: 'LeckerliOne',
      ),
      bodyLarge: TextStyle(
          fontSize: 30,
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(
          fontSize: 25,
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.bold),
      bodySmall: TextStyle(
          fontSize: 18,
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.bold),
      labelMedium: TextStyle(
          fontSize: 16,
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(107, 107, 107, 1)),
    ),
    useMaterial3: true,
  );
}
