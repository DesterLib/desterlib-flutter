// External packages
import 'package:flutter/cupertino.dart';

// Re-export CupertinoActivityIndicator for convenience
export 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

/// Simple spinner widget wrapper around CupertinoActivityIndicator
class DSpinner extends StatelessWidget {
  final Color? color;
  final double size;
  final double strokeWidth; // Ignored, kept for API compatibility

  const DSpinner({
    super.key,
    this.color,
    this.size = 24.0,
    this.strokeWidth = 2.5, // Ignored
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CupertinoActivityIndicator(radius: size / 2, color: color),
    );
  }
}
