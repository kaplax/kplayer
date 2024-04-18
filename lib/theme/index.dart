import 'package:flutter/material.dart';

class KThemeColor {
  static const Color background = Color(0xFF1E1E1E);
  static const Color bodyBackground = Color(0xFF2E2E2E);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: KThemeColor.background,
    ),
    scaffoldBackgroundColor: KThemeColor.background,
    colorScheme: const ColorScheme(
      primary: KThemeColor.background,
      brightness: Brightness.dark,
      background: KThemeColor.background,
      onPrimary: KThemeColor.background,
      secondary: KThemeColor.bodyBackground,
      onSecondary: KThemeColor.background,
      error: KThemeColor.background,
      onError: KThemeColor.background,
      onBackground: KThemeColor.background,
      surface: KThemeColor.background,
      onSurface: KThemeColor.background,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );
}
