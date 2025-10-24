import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_features.dart';
import '../features/library/library_features.dart';
import '../features/settings/settings_features.dart';
import '../features/media/media_features.dart';
import '../shared/widgets/ui/bottom_nav_bar.dart';
import '../shared/widgets/ui/sidebar/sidebar.dart';
import '../shared/widgets/drawer_content.dart';
import '../shared/utils/platform_icons.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithTransition(state, const HomeScreen());
          },
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithTransition(state, const LibraryScreen());
          },
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithTransition(state, const SettingsScreen());
          },
        ),
        GoRoute(
          path: '/media/:id',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return _buildPageWithTransition(state, MediaDetailScreen(id: id));
          },
        ),
      ],
    ),
  ],
);

CustomTransitionPage _buildPageWithTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 1.02;
      const end = 1.0;
      final scaleTween = Tween(begin: begin, end: end);

      // Outer wrapper: just fade
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
        child: Container(
          color: const Color(0xFF0a0a0a),
          child: ScaleTransition(
            scale: animation.drive(
              scaleTween.chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          ),
        ),
      );
    },
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Show sidebar on desktop and TV screens (> 900px width)
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 900;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: !showSidebar
          ? DBottomNavBar(
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => _onItemTapped(index, context),
              items: [
                DBottomNavBarItem(
                  icon: PlatformIcons.home,
                  selectedIcon: PlatformIcons.home,
                  label: 'Home',
                ),
                DBottomNavBarItem(
                  icon: PlatformIcons.videoLibrary,
                  selectedIcon: PlatformIcons.videoLibrary,
                  label: 'Library',
                ),
                DBottomNavBarItem(
                  icon: PlatformIcons.settings,
                  selectedIcon: PlatformIcons.settings,
                  label: 'Settings',
                ),
              ],
            )
          : null,
      // Add the drawer content widget to listen for state changes
      body: showSidebar 
          ? _DesktopLayout(child: child) 
          : Stack(
              children: [
                child,
                const DrawerContent(),
              ],
            ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/library')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/library');
      case 2:
        context.go('/settings');
    }
  }
}

class _DesktopLayout extends StatelessWidget {
  final Widget child;

  const _DesktopLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content area with left padding for sidebar
        Positioned.fill(
          left: 340, // Space for sidebar with margins
          child: child,
        ),
        // Floating sidebar on the left
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: DSidebar(
            currentIndex: ScaffoldWithNavBar._calculateSelectedIndex(context),
            items: [
              DSidebarNavigationItem(
                label: 'Home',
                icon: PlatformIcons.home,
                onTap: () => context.go('/'),
              ),
              DSidebarNavigationItem(
                label: 'Library',
                icon: PlatformIcons.videoLibrary,
                onTap: () => context.go('/library'),
              ),
              DSidebarNavigationItem(
                label: 'Settings',
                icon: PlatformIcons.settings,
                onTap: () => context.go('/settings'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
