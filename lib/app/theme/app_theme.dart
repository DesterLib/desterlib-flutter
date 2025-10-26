import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF00FFB3);
  static const Color _darkBg = Color(0xFF0a0a0a);

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      useMaterial3: true,
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: _darkBg,
    );
  }
}
