import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'app/router.dart';
import 'core/config/api_config.dart';

void main() async {
  // Enable performance optimizations
  WidgetsFlutterBinding.ensureInitialized();

  // Set minimum window size for desktop platforms
  await _setMinimumWindowSize();

  // Load API configuration
  await ApiConfig.loadBaseUrl();

  // Precompile shaders for better performance
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50MB

  runApp(const ProviderScope(child: MainApp()));
}

Future<void> _setMinimumWindowSize() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set minimum window size for desktop platforms
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // For desktop platforms, set minimum window size
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // This will be handled by the platform-specific window configuration
      // The actual implementation depends on the platform
    }
  } catch (e) {
    // Ignore errors if not supported on the platform
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dester',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00FFB3)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00FFB3),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0a0a0a),
      ),
      routerConfig: router,
    );
  }
}
