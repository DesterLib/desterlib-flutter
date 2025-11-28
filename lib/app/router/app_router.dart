// External packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:dester/features/connection/presentation/widgets/connection_guard_wrapper.dart';
import 'package:dester/core/widgets/d_scaffold.dart';
import 'package:dester/core/widgets/fade_page_transition.dart';
import 'package:dester/core/storage/preferences_service.dart';

// Features
import 'package:dester/features/home/home_feature.dart';
import 'package:dester/features/settings/settings_feature.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // Note: Home screen is now a ConsumerWidget that manages its own state via Riverpod
  static const ValueKey<String> _homeScreenKey = ValueKey<String>(
    'home_screen',
  );

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      // Check if API is configured before allowing navigation to home
      final apiUrl = PreferencesService.getActiveApiUrl();
      final isConnectionSetup = state.uri.path == '/connection-setup';

      // If no API configured and not already on connection setup, redirect there
      if ((apiUrl == null || apiUrl.isEmpty) && !isConnectionSetup) {
        return '/connection-setup';
      }

      // If API is configured and on connection setup, allow navigation (user might be managing APIs)
      // Don't auto-redirect away from connection setup if API exists
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ConnectionGuardWrapper(child: child);
        },
        routes: [
          // Connection setup route (outside DScaffold - no bottom nav, no back button)
          GoRoute(
            path: '/connection-setup',
            name: 'connection-setup',
            pageBuilder: (context, state) => CupertinoPage(
              child: SettingsFeature.createConnectionSetupScreen(),
              key: state.pageKey,
            ),
          ),
          ShellRoute(
            builder: (context, state, child) {
              return DScaffold(child: child);
            },
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (context, state) => fadeTransitionPage(
                  HomeFeature.createHomeScreen(),
                  state,
                  pageKey: _homeScreenKey,
                ),
              ),
              GoRoute(
                path: '/settings',
                name: 'settings',
                pageBuilder: (context, state) => fadeTransitionPage(
                  SettingsFeature.createSettingsScreen(),
                  state,
                ),
                routes: [
                  GoRoute(
                    path: 'apis',
                    name: 'manage-apis',
                    pageBuilder: (context, state) => CupertinoPage(
                      child: SettingsFeature.createApiManagementScreen(),
                      key: state.pageKey,
                    ),
                  ),
                  GoRoute(
                    path: 'libraries',
                    name: 'manage-libraries',
                    pageBuilder: (context, state) => CupertinoPage(
                      child: SettingsFeature.createManageLibrariesScreen(),
                      key: state.pageKey,
                    ),
                  ),
                  GoRoute(
                    path: 'metadata-providers',
                    name: 'metadata-providers',
                    pageBuilder: (context, state) => CupertinoPage(
                      child: SettingsFeature.createMetadataProvidersScreen(),
                      key: state.pageKey,
                    ),
                  ),
                  GoRoute(
                    path: 'scan-settings',
                    name: 'scan-settings',
                    pageBuilder: (context, state) => CupertinoPage(
                      child: SettingsFeature.createScanSettingsScreen(),
                      key: state.pageKey,
                    ),
                    routes: [
                      GoRoute(
                        path: 'movie',
                        name: 'movie-scan-settings',
                        pageBuilder: (context, state) => CupertinoPage(
                          child:
                              SettingsFeature.createMovieScanSettingsScreen(),
                          key: state.pageKey,
                        ),
                      ),
                      GoRoute(
                        path: 'tv',
                        name: 'tv-scan-settings',
                        pageBuilder: (context, state) => CupertinoPage(
                          child: SettingsFeature.createTvScanSettingsScreen(),
                          key: state.pageKey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
