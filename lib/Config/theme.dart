import 'package:flutter/material.dart';

class ThemeClass {
  static Color blueThemeColor = Color.fromRGBO(206, 240, 252, 1);
  static Color greenThemeColor = Color.fromRGBO(204, 244, 193, 1);
  static Color yellowThemeColor = Color.fromRGBO(244, 237, 193, 1);

  static ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: blueThemeColor),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 35,
        fontFamily: 'LeckerliOne',
      ),
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

  static textFormFieldDecoration({Icon? prefixIcon, Widget? suffixWidget}) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffix: suffixWidget,
      contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 14),
      filled: true,
      fillColor: Color.fromRGBO(230, 255, 252, 1),
      isDense: true,
      border: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Color.fromRGBO(111, 224, 248, 1)),
          borderRadius: BorderRadius.circular(35)),
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
          borderRadius: BorderRadius.circular(35)),
      errorStyle: TextStyle(
        color: Color.fromRGBO(240, 41, 41, 1),
        fontSize: 14, // Adjust the error message size
      ),
    );
  }

  static InputDecorationTheme dropdownMenuDecoration() {
    return InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        filled: true,
        fillColor: Color.fromRGBO(230, 255, 252, 1),
        disabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Color.fromRGBO(111, 224, 248, 1)),
            borderRadius: BorderRadius.circular(35)),
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

  static MenuStyle dropdownMenuStyle() {
    return MenuStyle(
        backgroundColor: WidgetStatePropertyAll(blueThemeColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ));
  }

  static String getCategoryImagePath(String? category) {
    switch (category) {
      case "Anniversary":
        return "assets/icons/CategoryIcons/anniversary.png";
      case "Wedding":
        return "assets/icons/CategoryIcons/wedding.png";
      case "Celebration Party":
        return "assets/icons/CategoryIcons/party.png";
      case "Birthday":
        return "assets/icons/CategoryIcons/birthday.png";
      case "Graduation":
        return "assets/icons/CategoryIcons/graduation.png";
      case "Baby Shower":
        return "assets/icons/CategoryIcons/baby.png";
      case "Engagement":
        return "assets/icons/CategoryIcons/engagement.png";
      case "Retirement":
        return "assets/icons/CategoryIcons/retirement.png";
      case "New Year's Eve":
        return "assets/icons/CategoryIcons/new_year.png";
      case "Farewell Party":
        return "assets/icons/CategoryIcons/farewell_party.png";
      case "Charity Event":
        return "assets/icons/CategoryIcons/charity.png";
      default:
        return "assets/icons/CategoryIcons/event.png";
    }
  }
}
