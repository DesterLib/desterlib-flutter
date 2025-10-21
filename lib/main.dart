import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'services/config_service.dart';
import 'features/home/repo/home_repository.dart';
import 'features/settings/repo/settings_repository.dart';
import 'features/details/repo/details_repository.dart';
import 'widgets/layouts/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit for video playback
  MediaKit.ensureInitialized();

  // Initialize ConfigService
  final configService = await ConfigService.create();

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

  runApp(RestartWidget(child: MyApp(configService: configService)));
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}

class MyApp extends StatefulWidget {
  final ConfigService configService;

  const MyApp({super.key, required this.configService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Use configured baseUrl or fallback to default
    final apiBaseUrl =
        widget.configService.apiBaseUrl ?? 'http://localhost:3001/api/v1';

    final homeRepository = HomeRepository(baseUrl: apiBaseUrl);
    final settingsRepository = SettingsRepository(baseUrl: apiBaseUrl);
    final detailsRepository = DetailsRepository(baseUrl: apiBaseUrl);

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
        configService: widget.configService,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
