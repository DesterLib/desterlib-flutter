import 'package:go_router/go_router.dart';

import 'package:desterlib_client/core/app/app_background.dart';
import 'package:desterlib_client/core/app/app_shell.dart';
import 'package:desterlib_client/core/router/transitions/fade_page.dart';
import 'package:desterlib_client/features/home/home_page.dart';
import 'package:desterlib_client/features/media/movie_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppBackground(child: AppShell(child: child));
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => state.fadePage(const HomePage()),
        ),
        GoRoute(
          path: '/media/movie',
          pageBuilder: (context, state) => state.fadePage(const MoviePage()),
        ),
      ],
    ),
  ],
);
