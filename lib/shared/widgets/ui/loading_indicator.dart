import 'package:flutter/material.dart';

/// Custom loading indicator with consistent styling across all platforms
/// Uses the same design as the cached image loading spinner
class DLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;

  const DLoadingIndicator({
    super.key,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? Colors.white.withValues(alpha: 0.5),
      strokeWidth: strokeWidth ?? 2,
    );
  }
}

