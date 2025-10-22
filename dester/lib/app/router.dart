import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_features.dart';
import '../features/library/library_features.dart';
import '../features/settings/settings_features.dart';
import '../shared/widgets/app_shell.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/library',
          builder: (BuildContext context, GoRouterState state) {
            return const LibraryScreen();
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
      ],
    ),
  ],
);
