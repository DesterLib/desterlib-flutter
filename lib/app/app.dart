import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import '../shared/widgets/splash_screen.dart';
import '../core/providers/websocket_provider.dart';

/// Root application widget that sets up theming and routing.
/// This wraps the ProviderScope and configures the Material app.
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Initialize WebSocket service early
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(websocketServiceProvider);
      ref.read(scanProgressProvider);
    });
  }

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: SplashScreen(onComplete: _onSplashComplete),
      );
    }

    return MaterialApp.router(
      title: 'Dester',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
