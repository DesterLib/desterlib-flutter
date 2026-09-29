import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class FadePage<T> extends CustomTransitionPage<T> {
  FadePage({
    required super.key,
    required super.child,
    Duration duration = const Duration(milliseconds: 220),
    Curve curve = Curves.easeOutCubic,
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final fadeIn = CurvedAnimation(
             parent: animation,
             curve: Interval(0.35, 1.0, curve: curve),
             reverseCurve: Interval(
               0.0,
               0.65,
               curve: Curves.easeInCubic,
             ).flipped,
           );

           final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
             CurvedAnimation(
               parent: secondaryAnimation,
               curve: Interval(0.0, 0.35, curve: Curves.easeInCubic),
               reverseCurve: Interval(
                 0.65,
                 1.0,
                 curve: Curves.easeOutCubic,
               ).flipped,
             ),
           );

           return FadeTransition(
             opacity: fadeIn,
             child: FadeTransition(opacity: fadeOut, child: child),
           );
         },
       );
}

extension GoRouterStateX on GoRouterState {
  Page<T> fadePage<T>(Widget child) => FadePage<T>(key: pageKey, child: child);
}
