import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';

/// Standardized loading screen that fills the entire viewport
/// Centered both vertically and horizontally
class DLoadingScreen extends StatelessWidget {
  final String? message;
  final Color backgroundColor;

  const DLoadingScreen({
    super.key,
    this.message,
    this.backgroundColor = const Color(0xFF0a0a0a),
  });

  @override
  Widget build(BuildContext context) {
    // Get full screen dimensions to ensure proper centering
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DLoadingIndicator(),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
