import 'package:flutter/widgets.dart';

@immutable
class AppTheme {
  final Gradient background;
  final Color surfaceLight;
  final Color surfaceMedium;
  final Color surfaceDark;
  final Color onSurface;
  final Brightness brightness;

  final Color black;
  final Color white;

  const AppTheme({
    required this.background,
    required this.surfaceLight,
    required this.surfaceMedium,
    required this.surfaceDark,
    required this.onSurface,
    required this.brightness,
    required this.black,
    required this.white,
  });

  bool get isDark => brightness == Brightness.dark;

  factory AppTheme.light() {
    return AppTheme(
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF7F7FA), Color(0xFFEDEDF2)],
      ),
      surfaceLight: const Color(0xFFFFFFFF),
      surfaceMedium: const Color(0xFFFFFFFF),
      surfaceDark: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFFFFFFFF),
      brightness: Brightness.light,
      black: const Color(0x00000000),
      white: const Color(0xFFFFFFFF),
    );
  }

  factory AppTheme.dark() {
    return AppTheme(
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF7F7FA), Color(0xFFEDEDF2)],
      ),
      surfaceLight: const Color(0xFFFFFFFF),
      surfaceMedium: const Color(0xFFFFFFFF),
      surfaceDark: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFFFFFFFF),
      brightness: Brightness.light,
      black: const Color(0x00000000),
      white: const Color(0xFFFFFFFF),
    );
  }
}
