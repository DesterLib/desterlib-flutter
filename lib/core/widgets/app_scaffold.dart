// External packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_bottom_navigation_bar.dart';

/// Scaffold wrapper that includes the bottom navigation bar
/// Wraps child widgets and adds bottom navigation bar
class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    // If child is a Scaffold, extract its properties and add bottom navigation
    if (child is Scaffold) {
      final scaffold = child as Scaffold;
      return Scaffold(
        key: scaffold.key,
        appBar: scaffold.appBar,
        body: Stack(
          children: [
            // Original scaffold body
            scaffold.body ?? const SizedBox.shrink(),
            // Floating bottom navigation bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavigationBar(currentRoute: currentRoute),
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
      );
    }

    // If child is not a Scaffold, wrap it in one
    return Scaffold(
      body: Stack(
        children: [
          // Original child content
          child,
          // Floating bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavigationBar(currentRoute: currentRoute),
          ),
        ],
      ),
    );
  }
}
