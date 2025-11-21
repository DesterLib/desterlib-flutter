import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/connection/presentation/widgets/connection_guard_wrapper.dart';
import '../../features/home/home_feature.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ConnectionGuardWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => HomeFeature.createHomeScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
