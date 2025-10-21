import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'features/home/repo/home_repository.dart';
import 'features/settings/repo/settings_repository.dart';
import 'features/details/repo/details_repository.dart';
import 'widgets/layouts/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit for video playback
  MediaKit.ensureInitialized();

  // Configure window for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String get _apiServerUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3001/api/v1'; // Android emulator
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return 'http://localhost:3001/api/v1'; // iOS/macOS
    }

    return 'http://localhost:3001/api/v1';
  }

  @override
  Widget build(BuildContext context) {
    final homeRepository = HomeRepository(baseUrl: _apiServerUrl);
    final settingsRepository = SettingsRepository(baseUrl: _apiServerUrl);
    final detailsRepository = DetailsRepository(baseUrl: _apiServerUrl);

    return MaterialApp(
      title: 'Dester Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AppShell(
        homeRepository: homeRepository,
        settingsRepository: settingsRepository,
        detailsRepository: detailsRepository,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
