class AppConfig {
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
  static const bool isRelease = !isDebug;
  
  // App Store specific configurations
  static const String appName = 'Dester';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
  
  // Performance optimizations for release
  static const bool enableDebugLogs = isDebug;
  static const bool enablePerformanceOverlay = isDebug;
  static const bool enableSemanticsDebugger = isDebug;
}
