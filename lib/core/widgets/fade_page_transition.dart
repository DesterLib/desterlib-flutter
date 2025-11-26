// External packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';

/// Helper function to create a page with fade transition
/// This can be reused for all routes that need fade animation
Page<T> fadeTransitionPage<T extends Object?>(
  Widget child,
  GoRouterState state, {
  Duration transitionDuration = AppConstants.fadeInDelay,
  LocalKey? pageKey,
}) {
  return CustomTransitionPage<T>(
    key: pageKey ?? state.pageKey,
    child: child,
    transitionDuration: transitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
