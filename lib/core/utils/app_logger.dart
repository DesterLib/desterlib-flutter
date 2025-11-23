// External packages
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';


/// Centralized logging utility for the app
/// Provides consistent logging across the application
class AppLogger {
  static Logger? _logger;

  /// Get the logger instance
  /// In debug mode, shows detailed logs with colors
  /// In release mode, only shows warnings and errors
  static Logger get logger {
    _logger ??= Logger(
      printer: PrettyPrinter(
        methodCount: kDebugMode ? 2 : 0,
        errorMethodCount: kDebugMode ? 8 : 0,
        lineLength: 120,
        colors: kDebugMode,
        printEmojis: kDebugMode,
        dateTimeFormat: kDebugMode
            ? DateTimeFormat.onlyTimeAndSinceStart
            : DateTimeFormat.none,
      ),
      level: kDebugMode ? Level.debug : Level.warning,
    );
    return _logger!;
  }

  /// Log debug messages (only in debug mode)
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info messages
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning messages
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error messages
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal errors
  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.f(message, error: error, stackTrace: stackTrace);
  }
}
