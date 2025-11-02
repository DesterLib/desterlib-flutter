import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 13.0;
  static const double fontSizeMD = 14.0;
  static const double fontSizeBase = 15.0;
  static const double fontSizeLG = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeXXXL = 24.0;
  static const double fontSizeHuge = 32.0;

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const TextStyle h1 = TextStyle(
    fontSize: fontSizeHuge,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    letterSpacing: letterSpacingTight,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: fontSizeXXXL,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    letterSpacing: letterSpacingTight,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: fontSizeXXL,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    letterSpacing: letterSpacingTight,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: fontSizeXL,
    fontWeight: medium,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeLG,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyBase = TextStyle(
    fontSize: fontSizeBase,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: regular,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: medium,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: medium,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSizeXS,
    fontWeight: medium,
    color: AppColors.textTertiary,
  );

  static const TextStyle button = TextStyle(
    fontSize: fontSizeBase,
    fontWeight: semiBold,
    letterSpacing: letterSpacingTight,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: semiBold,
    letterSpacing: letterSpacingTight,
  );
}
