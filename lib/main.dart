// Dart
import 'dart:io';

// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

// Core
import 'app/router/app_router.dart';
import 'core/storage/preferences_service.dart';
import 'core/network/api_provider.dart';

// Features
import 'features/home/home_feature.dart';
import 'features/media_details/media_details_feature.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window_manager (required for desktop platforms only)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
  }

  await EasyLocalization.ensureInitialized();

  // Initialize preferences service before router (needed for redirect logic)
  await PreferencesService.init();

  // Initialize API provider - use saved URL if available, otherwise use placeholder
  // The placeholder prevents crashes when features try to access ApiProvider.instance
  // The router will redirect to connection-setup if no real API is configured
  final savedApiUrl = PreferencesService.getActiveApiUrl();
  if (savedApiUrl != null && savedApiUrl.isNotEmpty) {
    ApiProvider.initialize(savedApiUrl);
  } else {
    // Initialize with placeholder URL to prevent crashes
    // Router will redirect to connection-setup before any API calls are made
    ApiProvider.initialize('http://placeholder.local');
  }

  runApp(
    ProviderScope(
      overrides: [...HomeFeature.overrides, ...MediaDetailsFeature.overrides],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dester',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          surface: Colors.black,
        ),
        cardColor: Colors.grey[900],
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: const Color(0xFF121212),
        ),
        // Apply Inter font throughout the app
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
