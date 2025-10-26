import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/api_config.dart';

/// Initializes the Flutter app with all required setup.
/// This includes binding initialization, window configuration, API config, and performance optimizations.
/// Note: The API client provider will be initialized lazily when first accessed via Riverpod.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup device orientation and UI mode
  await _setupDeviceConfiguration();

  // Load API configuration - must be done before the app runs
  await ApiConfig.loadBaseUrl();

  // Setup image cache for performance
  _setupImageCache();
}

/// Configures device orientation and system UI mode for all platforms.
Future<void> _setupDeviceConfiguration() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  } catch (e) {
    // Platform may not support these configurations
  }
}

/// Configures the image cache for optimal performance.
void _setupImageCache() {
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50MB
}
