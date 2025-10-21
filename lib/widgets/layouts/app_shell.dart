import 'package:flutter/material.dart';
import '../common/app_navbar.dart';
import '../../features/home/view/home_page.dart';
import '../../features/home/repo/home_repository.dart';
import '../../features/settings/view/settings_page.dart';
import '../../features/settings/repo/settings_repository.dart';
import '../../features/details/view/details_page.dart';
import '../../features/details/repo/details_repository.dart';

class AppShell extends StatefulWidget {
  final HomeRepository homeRepository;
  final SettingsRepository settingsRepository;
  final DetailsRepository detailsRepository;

  const AppShell({
    super.key,
    required this.homeRepository,
    required this.settingsRepository,
    required this.detailsRepository,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String _currentRoute = '/';
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Stack(
        children: [
          // Content area - this is where pages will render
          Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              // Update current route without rebuilding navbar
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _currentRoute != settings.name) {
                  setState(() {
                    _currentRoute = settings.name ?? '/';
                  });
                }
              });

              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return _buildPage(settings.name ?? '/', settings.arguments);
                },
                transitionDuration: const Duration(milliseconds: 200),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      // Fade out old page and fade in new page
                      // This prevents overlap by ensuring only the new page is visible
                      return FadeTransition(
                        opacity: animation,
                        child: Container(
                          color: Colors.grey.shade900,
                          child: child,
                        ),
                      );
                    },
              );
            },
          ),
          // Fixed navbar on top - stays fixed, never rebuilds with route changes
          AppNavBar(currentRoute: _currentRoute, navigatorKey: _navigatorKey),
        ],
      ),
    );
  }

  Widget _buildPage(String route, Object? arguments) {
    switch (route) {
      case '/':
        return HomePage(homeRepository: widget.homeRepository);
      case '/settings':
        return SettingsPage(settingsRepository: widget.settingsRepository);
      case '/details':
        if (arguments is Map<String, dynamic>) {
          final mediaId = arguments['mediaId'] as String;
          final type = arguments['type'] as String;
          return DetailsPage(
            mediaId: mediaId,
            mediaType: type,
            detailsRepository: widget.detailsRepository,
          );
        }
        return HomePage(homeRepository: widget.homeRepository);
      default:
        return HomePage(homeRepository: widget.homeRepository);
    }
  }
}
