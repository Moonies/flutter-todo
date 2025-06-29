import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors
  static const Color _lightPrimaryColor = Colors.blue;
  // static const Color _lightBackgroundColor = Colors.white;

  // Dark theme colors
  static const Color _darkPrimaryColor = Color.fromARGB(255, 44, 91, 172);
  // static const Color _darkBackgroundColor = Color(0xFF121212);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // colorScheme: ColorScheme.light(
    //   primary: _lightPrimaryColor,
    //   surface: _lightBackgroundColor,
    // ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightPrimaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    // navigationRailTheme: NavigationRailThemeData(
    //   backgroundColor: _lightBackgroundColor,
    //   selectedIconTheme: const IconThemeData(color: _lightPrimaryColor),
    //   selectedLabelTextStyle: TextStyle(color: _lightPrimaryColor),
    // ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // colorScheme: ColorScheme.dark(
    //   primary: _darkPrimaryColor,
    //   surface: _darkBackgroundColor,
    // ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkPrimaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    // navigationRailTheme: NavigationRailThemeData(
    //   backgroundColor: _darkBackgroundColor,
    //   selectedIconTheme: const IconThemeData(color: _darkPrimaryColor),
    //   selectedLabelTextStyle: TextStyle(color: _darkPrimaryColor),
    // ),
  );
}
