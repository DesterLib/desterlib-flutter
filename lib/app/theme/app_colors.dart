import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00FFB3);
  static const Color primaryDark = Color(0xFF00CC8F);
  static const Color primaryLight = Color(0xFF66FFD4);

  static const Color background = Color(0xFF0a0a0a);
  static const Color backgroundElevated = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF2A2A2A);
  static const Color surfaceElevated = Color(0xFF3A3A3A);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textDisabled = Color(0xFF4A4A4A);

  static const Color border = Color(0xFF3A3A3A);
  static const Color borderLight = Color(0xFF4A4A4A);
  static const Color borderDark = Color(0xFF2A2A2A);

  static const Color success = Color(0xFF00FFB3);
  static const Color error = Color(0xFFFF4444);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF00A8FF);
  static const Color danger = error;

  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xB3000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, backgroundElevated],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
