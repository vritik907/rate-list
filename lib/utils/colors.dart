import 'package:flutter/material.dart';

const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;

final ThemeData appTheme = ThemeData(
  primarySwatch: MaterialColor(blueColor.value, {
    50: blueColor.withOpacity(0.1),
    100: blueColor.withOpacity(0.2),
    200: blueColor.withOpacity(0.3),
    300: blueColor.withOpacity(0.4),
    400: blueColor.withOpacity(0.5),
    500: blueColor,
    600: blueColor.withOpacity(0.7),
    700: blueColor.withOpacity(0.8),
    800: blueColor.withOpacity(0.9),
    900: blueColor.withOpacity(1),
  }),
  colorScheme: ColorScheme.dark(
    primary: blueColor,
    secondary: secondaryColor,
    surface: webBackgroundColor,
  ),
  scaffoldBackgroundColor: mobileBackgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: webBackgroundColor,
    elevation: 0,
  ),
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: primaryColor),
    bodyLarge: TextStyle(fontSize: 16, color: primaryColor),
    bodyMedium: TextStyle(fontSize: 14, color: secondaryColor),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: mobileSearchColor,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    ),
    hintStyle: TextStyle(color: secondaryColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: primaryColor, backgroundColor: blueColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);