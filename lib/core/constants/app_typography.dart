// External packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography constants using Inter font from Google Fonts
/// Provides centralized text styles for consistent typography throughout the app
class AppTypography {
  AppTypography._(); // Private constructor to prevent instantiation

  // Font sizes
  static const double fontSizeXs = 12;
  static const double fontSizeSm = 14;
  static const double fontSizeMd = 16;
  static const double fontSizeLg = 18;
  static const double fontSizeXl = 20;
  static const double fontSize2xl = 24;
  static const double fontSize3xl = 32;
  static const double fontSize4xl = 40;
  static const double fontSize5xl = 48;

  // Font weights
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;

  /// Base Inter font text style helper
  /// Use this to create custom text styles with Inter font
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight ?? weightRegular,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // Display styles (largest text)
  static TextStyle displayLarge({Color? color}) =>
      inter(fontSize: fontSize5xl, fontWeight: weightSemiBold, color: color);

  static TextStyle displayMedium({Color? color}) =>
      inter(fontSize: fontSize4xl, fontWeight: weightSemiBold, color: color);

  static TextStyle displaySmall({Color? color}) =>
      inter(fontSize: fontSize3xl, fontWeight: weightSemiBold, color: color);

  // Headline styles
  static TextStyle headlineLarge({Color? color}) =>
      inter(fontSize: fontSize2xl, fontWeight: weightSemiBold, color: color);

  static TextStyle headlineMedium({Color? color}) =>
      inter(fontSize: fontSizeXl, fontWeight: weightSemiBold, color: color);

  static TextStyle headlineSmall({Color? color}) =>
      inter(fontSize: fontSizeLg, fontWeight: weightSemiBold, color: color);

  // Title styles
  static TextStyle titleLarge({Color? color}) =>
      inter(fontSize: fontSizeLg, fontWeight: weightSemiBold, color: color);

  static TextStyle titleMedium({Color? color}) =>
      inter(fontSize: fontSizeMd, fontWeight: weightSemiBold, color: color);

  static TextStyle titleSmall({Color? color}) =>
      inter(fontSize: fontSizeSm, fontWeight: weightSemiBold, color: color);

  // Body styles
  static TextStyle bodyLarge({Color? color}) =>
      inter(fontSize: fontSizeMd, fontWeight: weightRegular, color: color);

  static TextStyle bodyMedium({Color? color}) =>
      inter(fontSize: fontSizeSm, fontWeight: weightRegular, color: color);

  static TextStyle bodySmall({Color? color}) =>
      inter(fontSize: fontSizeXs, fontWeight: weightRegular, color: color);

  // Label styles (for buttons, labels, etc.)
  static TextStyle labelLarge({Color? color}) =>
      inter(fontSize: fontSizeSm, fontWeight: weightSemiBold, color: color);

  static TextStyle labelMedium({Color? color}) =>
      inter(fontSize: fontSizeXs, fontWeight: weightSemiBold, color: color);

  static TextStyle labelSmall({Color? color}) =>
      inter(fontSize: fontSizeXs, fontWeight: weightMedium, color: color);

  // Button styles
  static TextStyle buttonLarge({Color? color}) =>
      inter(fontSize: fontSizeMd, fontWeight: weightSemiBold, color: color);

  static TextStyle buttonMedium({Color? color}) =>
      inter(fontSize: fontSizeMd, fontWeight: weightSemiBold, color: color);

  static TextStyle buttonSmall({Color? color}) =>
      inter(fontSize: fontSizeSm, fontWeight: weightSemiBold, color: color);

  // Navigation styles
  static TextStyle navLabel({Color? color, bool isSelected = false}) => inter(
    fontSize: fontSizeSm,
    fontWeight: isSelected ? weightSemiBold : weightMedium,
    color: color,
  );

  static TextStyle navLabelSmall({Color? color, bool isSelected = false}) =>
      inter(
        fontSize: fontSizeXs,
        fontWeight: isSelected ? weightSemiBold : weightMedium,
        color: color,
      );
}
