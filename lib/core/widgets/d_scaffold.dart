// Dart
import 'dart:io';

// External packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'd_bottom_navigation_bar.dart';
import 'd_sidebar.dart';

/// Scaffold wrapper that includes navigation (sidebar on desktop, bottom nav on mobile)
/// Wraps child widgets and adds appropriate navigation based on platform/screen size
class DScaffold extends StatelessWidget {
  final Widget child;

  const DScaffold({super.key, required this.child});

  /// Check if running on desktop platform
  static bool get isDesktop {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// Check if screen is wide enough for desktop layout
  static bool isDesktopLayout(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768;
  }

  /// Check if bottom navigation bar should be shown
  /// Only show on home screen (/) and settings root screen (/settings)
  static bool shouldShowBottomNav(String currentRoute) {
    return currentRoute == '/' || currentRoute == '/settings';
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final useDesktopLayout = isDesktop && isDesktopLayout(context);
    final showBottomNav = shouldShowBottomNav(currentRoute);

    // If child is a Scaffold, extract its properties and add navigation
    if (child is Scaffold) {
      final scaffold = child as Scaffold;

      if (useDesktopLayout) {
        // Desktop layout with floating sidebar
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            key: scaffold.key,
            appBar: scaffold.appBar,
            body: Stack(
              children: [
                // Original scaffold body
                scaffold.body ?? const SizedBox.shrink(),
                // Floating sidebar
                Positioned(
                  left: AppConstants.spacing8,
                  top: AppConstants.spacing8,
                  bottom: AppConstants.spacing8,
                  child: DSidebar(currentRoute: currentRoute),
                ),
              ],
            ),
            backgroundColor: scaffold.backgroundColor,
            resizeToAvoidBottomInset: scaffold.resizeToAvoidBottomInset,
            floatingActionButton: scaffold.floatingActionButton,
            floatingActionButtonLocation: scaffold.floatingActionButtonLocation,
            drawer: scaffold.drawer,
            endDrawer: scaffold.endDrawer,
            bottomSheet: scaffold.bottomSheet,
            persistentFooterButtons: scaffold.persistentFooterButtons,
          ),
        );
      } else {
        // Mobile layout with bottom navigation
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            key: scaffold.key,
            appBar: scaffold.appBar,
            body: Stack(
              children: [
                // Original scaffold body
                scaffold.body ?? const SizedBox.shrink(),
                // Floating bottom navigation bar (only on home and settings root)
                if (showBottomNav)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: DBottomNavigationBar(currentRoute: currentRoute),
                  ),
              ],
            ),
            backgroundColor: scaffold.backgroundColor,
            resizeToAvoidBottomInset: scaffold.resizeToAvoidBottomInset,
            floatingActionButton: scaffold.floatingActionButton,
            floatingActionButtonLocation: scaffold.floatingActionButtonLocation,
            drawer: scaffold.drawer,
            endDrawer: scaffold.endDrawer,
            bottomSheet: scaffold.bottomSheet,
            persistentFooterButtons: scaffold.persistentFooterButtons,
          ),
        );
      }
    }

    // If child is not a Scaffold, wrap it in one
    if (useDesktopLayout) {
      // Desktop layout with floating sidebar
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Stack(
            children: [
              // Original child content
              child,
              // Floating sidebar
              Positioned(
                left: AppConstants.spacing8,
                top: AppConstants.spacing8,
                bottom: AppConstants.spacing8,
                child: DSidebar(currentRoute: currentRoute),
              ),
            ],
          ),
        ),
      );
    } else {
      // Mobile layout with bottom navigation
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Stack(
            children: [
              // Original child content
              child,
              // Floating bottom navigation bar (only on home and settings root)
              if (showBottomNav)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DBottomNavigationBar(currentRoute: currentRoute),
                ),
            ],
          ),
        ),
      );
    }
  }
}
