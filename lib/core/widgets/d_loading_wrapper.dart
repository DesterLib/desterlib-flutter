import 'package:flutter/material.dart';
import 'package:dester/core/widgets/d_spinner.dart';

class DLoadingWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loader;
  final Duration duration;
  final Curve curve;
  final bool centerLoader;

  const DLoadingWrapper({
    super.key,
    required this.isLoading,
    required this.child,
    this.loader,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.centerLoader = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      child: isLoading
          ? (centerLoader
                ? Center(
                    key: const ValueKey('loader'),
                    child: loader ?? const DSpinner(),
                  )
                : KeyedSubtree(
                    key: const ValueKey('loader'),
                    child: loader ?? const DSpinner(),
                  ))
          : KeyedSubtree(key: const ValueKey('content'), child: child),
    );
  }
}
