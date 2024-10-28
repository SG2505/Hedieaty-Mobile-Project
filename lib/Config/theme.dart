import 'package:flutter/material.dart';

class ThemeClass {
  static Color blueThemeColor = Color.fromRGBO(206, 240, 252, 1);
  static Color greenThemeColor = Color.fromRGBO(204, 244, 193, 1);

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
    //////////////List Tile Theme///////////////////
    listTileTheme: ListTileThemeData(
      tileColor: const Color.fromRGBO(206, 240, 252, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    useMaterial3: true,
  );

  static textFormFieldDecoration(String errorText) {
    return InputDecoration(
        //errorText: errorText,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        filled: true,
        fillColor: Color.fromRGBO(230, 255, 252, 1),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(111, 224, 248, 1)),
            borderRadius: BorderRadius.circular(35)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(111, 224, 248, 1)),
            borderRadius: BorderRadius.circular(35)),
        errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(240, 41, 41, 1)),
            borderRadius: BorderRadius.circular(35)));
  }

  static InputDecorationTheme dropdownMenuDecoration() {
    return InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        filled: true,
        fillColor: Color.fromRGBO(230, 255, 252, 1),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(111, 224, 248, 1)),
            borderRadius: BorderRadius.circular(35)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(111, 224, 248, 1)),
            borderRadius: BorderRadius.circular(35)),
        errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(240, 41, 41, 1)),
            borderRadius: BorderRadius.circular(35)));
  }
}
