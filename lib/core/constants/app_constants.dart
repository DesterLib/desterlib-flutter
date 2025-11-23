// External packages
import 'package:flutter/material.dart';


/// Application-wide constants following Tailwind-style utility system
class AppConstants {
  // Spacing scale (Tailwind-style: 0, 1, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, etc.)
  static const double spacing0 = 0;
  static const double spacing1 = 1;
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  // Semantic spacing aliases (for common use cases)
  static const double spacingXs = spacing4;
  static const double spacingSm = spacing8;
  static const double spacingMd = spacing16;
  static const double spacingLg = spacing24;
  static const double spacingXl = spacing32;
  static const double spacing2xl = spacing48;

  // Duration scale (milliseconds)
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationSlower = Duration(milliseconds: 1000);

  // Duration scale (seconds)
  static const Duration duration1s = Duration(seconds: 1);
  static const Duration duration2s = Duration(seconds: 2);
  static const Duration duration3s = Duration(seconds: 3);
  static const Duration duration5s = Duration(seconds: 5);

  // Semantic duration aliases
  static const Duration fadeTransition = durationNormal;
  static const Duration fadeInDelay = Duration(milliseconds: 200);
  static const Duration minimumSpinnerDisplay = duration2s;
  static const Duration additionalDelay = duration1s;
  static const Duration networkTimeout = duration5s;

  // Border radius scale
  static const double radiusNone = 0;
  static const double radiusSm = 2;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radius2xl = 20;
  static const double radius3xl = 24;
  static const double radiusFull = 9999;

  // Semantic border radius aliases
  static const double radiusCard = radiusMd;
  static const double radiusBottomSheet = radius3xl;
  static const double radiusButton = radiusMd;
  static const double radiusSettingsGroup = radius3xl;

  // Size scale (for widths, heights, icons, etc.)
  static const double sizeXs = 12;
  static const double sizeSm = 16;
  static const double sizeMd = 20;
  static const double sizeLg = 24;
  static const double sizeXl = 32;
  static const double size2xl = 48;
  static const double size3xl = 64;
  static const double size4xl = 96;

  // Modal/Dialog constraints
  static const double modalMaxWidth = 500;
  static const double modalMaxHeight = 600;

  // Common EdgeInsets utilities
  static EdgeInsets padding(double value) => EdgeInsets.all(value);
  static EdgeInsets paddingX(double value) =>
      EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets paddingY(double value) =>
      EdgeInsets.symmetric(vertical: value);
  static EdgeInsets paddingOnly({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) => EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);

  // Common SizedBox utilities
  static SizedBox spacing({double? width, double? height}) =>
      SizedBox(width: width, height: height);
  static SizedBox spacingX(double width) => SizedBox(width: width);
  static SizedBox spacingY(double height) => SizedBox(height: height);

  // Color constants
  static const Color accentColor = Color(0xFF00FFB3);
  static const Color successColor = Color(0xFF10B981); // Emerald green
  static const Color infoColor = Color(0xFF2563EB);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color dangerColor = Color(0xFFEF4444);
}
