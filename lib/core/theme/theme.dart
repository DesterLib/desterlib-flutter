import 'package:flutter/widgets.dart';

@immutable
class AppTheme {
  final Color onBackground;
  final Color surfaceLight;
  final Color surfaceMedium;
  final Color surfaceDark;
  final Color onSurface;
  final Color primary;
  final Color primaryHover;
  final Color onPrimary;
  final Brightness mode;

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  static const transitionDurationGeneric = Duration(milliseconds: 300);

  const AppTheme({
    required this.onBackground,
    required this.surfaceLight,
    required this.surfaceMedium,
    required this.surfaceDark,
    required this.onSurface,
    required this.primary,
    required this.primaryHover,
    required this.onPrimary,
    required this.mode,
  });

  bool get isDark => mode == Brightness.dark;

  AppTextTheme get textTheme => AppTextTheme(
    body: TextStyle(color: onBackground, fontSize: 14, height: 1.4),
    title: TextStyle(
      color: onBackground,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    button: TextStyle(
      color: onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  AppTheme lerp(AppTheme other, double t) {
    return AppTheme(
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      surfaceMedium: Color.lerp(surfaceMedium, other.surfaceMedium, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      primary: other.primary,
      primaryHover: other.primaryHover,
      onPrimary: other.onPrimary,
      mode: other.mode,
    );
  }

  static const _light = AppTheme(
    onBackground: Color(0xFF0F1116),
    surfaceLight: Color.fromRGBO(255, 255, 255, 0.1),
    surfaceMedium: Color.fromRGBO(255, 255, 255, 0.6),
    surfaceDark: Color.fromRGBO(255, 255, 255, 0.8),
    onSurface: Color.fromRGBO(0, 0, 0, 0.8),
    primary: Color.fromRGBO(255, 255, 255, 1),
    primaryHover: Color.fromRGBO(255, 255, 255, 0.8),
    onPrimary: Color.fromRGBO(0, 0, 0, 1),
    mode: Brightness.light,
  );

  static const _dark = AppTheme(
    onBackground: Color(0xFF0F1116),
    surfaceLight: Color.fromRGBO(0, 0, 0, 0.1),
    surfaceMedium: Color.fromRGBO(0, 0, 0, 0.6),
    surfaceDark: Color.fromRGBO(0, 0, 0, 0.8),
    onSurface: Color.fromRGBO(255, 255, 255, 0.8),
    primary: Color.fromRGBO(255, 255, 255, 1),
    primaryHover: Color.fromRGBO(255, 255, 255, 0.8),
    onPrimary: Color.fromRGBO(0, 0, 0, 1),
    mode: Brightness.dark,
  );

  factory AppTheme.light() => _light;
  factory AppTheme.dark() => _dark;
}

@immutable
class AppTextTheme {
  const AppTextTheme({
    required this.body,
    required this.title,
    required this.button,
  });
  final TextStyle body;
  final TextStyle title;
  final TextStyle button;
}
