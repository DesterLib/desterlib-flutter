import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_features.dart';
import '../features/library/library_features.dart';
import '../features/settings/settings_features.dart';
import '../features/media/media_features.dart';
import '../shared/widgets/ui/bottom_nav_bar.dart';
import '../shared/widgets/ui/sidebar/sidebar.dart';
import '../shared/widgets/connection_guard.dart';
import '../shared/widgets/drawer_widgets.dart';
import '../shared/utils/platform_icons.dart';
import '../core/providers/connection_provider.dart';

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
            return _buildPageWithTransition(
              state,
              const ConnectionGuard(child: HomeScreen()),
            );
          },
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithTransition(
              state,
              const ConnectionGuard(child: LibraryScreen()),
            );
          },
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithTransition(
              state,
              const ConnectionGuard(child: SettingsScreen()),
            );
          },
          routes: [
            GoRoute(
              path: 'manage-libraries',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return _buildPageWithTransition(
                  state,
                  const ConnectionGuard(child: ManageLibrariesScreen()),
                );
              },
              routes: [
                GoRoute(
                  path: 'edit/:id',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    final id = state.pathParameters['id']!;
                    return _buildPageWithTransition(
                      state,
                      ConnectionGuard(child: EditLibraryScreen(libraryId: id)),
                    );
                  },
                ),
                GoRoute(
                  path: 'delete/:id',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    final id = state.pathParameters['id']!;
                    return _buildPageWithTransition(
                      state,
                      ConnectionGuard(
                        child: DeleteLibraryScreen(libraryId: id),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/media/:id',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return _buildPageWithTransition(
              state,
              ConnectionGuard(child: MediaDetailScreen(id: id)),
            );
          },
        ),
        GoRoute(
          path: '/drawer/tmdb-api-key',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildModalPage(const TmdbApiKeyDrawer());
          },
        ),
        GoRoute(
          path: '/drawer/tmdb-required',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildModalPage(const TmdbRequiredDrawer());
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

CustomTransitionPage _buildModalPage(Widget child) {
  return CustomTransitionPage(
    key: const ValueKey('modal'),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();

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

  static void _onItemTapped(int index, BuildContext context) {
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

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Initialize to 0, will be updated in didChangeDependencies
    _selectedIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate selected index based on current route
    final newIndex = ScaffoldWithNavBar._calculateSelectedIndex(context);
    final currentPath = GoRouterState.of(context).uri.path;

    // Don't update if we're on a drawer route
    if (!currentPath.startsWith('/drawer/')) {
      _selectedIndex = newIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatus = ref.watch(connectionStatusProvider);
    final isConnected = connectionStatus == ConnectionStatus.connected;

    // Show sidebar on desktop and TV screens (> 900px width)
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 900;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: !showSidebar && isConnected
          ? DBottomNavBar(
              currentIndex: _selectedIndex,
              onTap: (index) =>
                  ScaffoldWithNavBar._onItemTapped(index, context),
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
      body: showSidebar && isConnected
          ? _DesktopLayout(selectedIndex: _selectedIndex, child: widget.child)
          : widget.child,
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const _DesktopLayout({required this.child, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Content area with left margin for sidebar
        Padding(padding: const EdgeInsets.only(left: 340), child: child),
        // Sidebar positioned on the left
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 340,
          child: DSidebar(
            currentIndex: selectedIndex,
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
