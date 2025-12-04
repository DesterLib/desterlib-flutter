// External packages
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// Skeleton loading widget with soft pulse animation
/// Used as a placeholder while content is loading
class DSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final bool enableShaderMask;
  final bool isMobile;

  const DSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.enableShaderMask = false,
    this.isMobile = false,
  });

  @override
  State<DSkeleton> createState() => _DSkeletonState();
}

class _DSkeletonState extends State<DSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey[800]!;
    final highlightColor = widget.highlightColor ?? Colors.grey[700]!;

    Widget skeleton = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.lerp(baseColor, highlightColor, _animation.value),
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );

    // Apply shader mask if enabled (matches hero image fade effect)
    if (widget.enableShaderMask) {
      skeleton = ShaderMask(
        shaderCallback: (Rect bounds) {
          return ui.Gradient.linear(
            const Offset(0, 0),
            Offset(0, bounds.height),
            [
              Colors.white, // Fully visible at top
              Colors.white.withValues(alpha: 0.8),
              Colors.white.withValues(alpha: 0.4),
              Colors.transparent, // Fully transparent at bottom
            ],
            [0.0, 0.3, 0.7, 1.0],
          );
        },
        blendMode: BlendMode.dstIn,
        child: widget.isMobile
            ? skeleton
            : ShaderMask(
                shaderCallback: (Rect bounds) {
                  return ui.Gradient.linear(
                    const Offset(0, 0),
                    Offset(bounds.width, 0),
                    [
                      Colors.transparent, // Transparent at left
                      Colors.white.withValues(alpha: 0.4),
                      Colors.white, // Fully visible at right
                    ],
                    [0.0, 0.2, 0.4],
                  );
                },
                blendMode: BlendMode.dstIn,
                child: skeleton,
              ),
      );
    }

    return skeleton;
  }
}

/// Skeleton box with standard styling
class DSkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const DSkeletonBox({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return DSkeleton(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
    );
  }
}
