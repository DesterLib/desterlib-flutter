import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:desterlib_client/core/app/app_background_state.dart';
import 'package:desterlib_client/core/app/app_background.dart';
import 'package:desterlib_client/core/app/app_shell.dart';
import 'package:desterlib_client/features/home/home_page.dart';
import 'package:desterlib_client/features/media/movie_page.dart';

final background = AppBackgroundState();

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppBackground(
          state: background,
          child: AppShell(
            background: background,
            child: KeyedSubtree(key: ValueKey(state.uri.path), child: child),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return HomePage();
          },
        ),

        GoRoute(
          path: '/media/movie',
          builder: (context, state) {
            return MoviePage(background: background);
          },
        ),
      ],
    ),
  ],
);
