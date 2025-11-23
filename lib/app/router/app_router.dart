// External packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:dester/core/connection/presentation/widgets/connection_guard_wrapper.dart';
import 'package:dester/core/widgets/app_scaffold.dart';
import 'package:dester/core/widgets/fade_page_transition.dart';

// Features
import 'package:dester/features/home/home_feature.dart';
import 'package:dester/features/settings/settings_feature.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ConnectionGuardWrapper(child: child);
        },
        routes: [
          ShellRoute(
            builder: (context, state, child) {
              return AppScaffold(child: child);
            },
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (context, state) =>
                    fadeTransitionPage(HomeFeature.createHomeScreen(), state),
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
