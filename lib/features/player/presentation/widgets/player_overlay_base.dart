import 'dart:ui';
import 'package:flutter/material.dart';

/// Base overlay widget with blur and tinted background
class BaseOverlay extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  final double blurAmount;
  final double tintOpacity;

  const BaseOverlay({
    super.key,
    required this.child,
    required this.onClose,
    this.blurAmount = 10.0,
    this.tintOpacity = 0.75,
  });

  @override
  State<BaseOverlay> createState() => BaseOverlayState();
}

class BaseOverlayState extends State<BaseOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Triggers the fade-out animation and then calls onClose
  Future<void> animateClose() async {
    await _controller.reverse();
    if (mounted) {
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FadeTransition(
        opacity: _animation,
      child: GestureDetector(
          onTap: animateClose,
        behavior: HitTestBehavior.opaque,
        child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blurAmount,
              sigmaY: widget.blurAmount,
            ),
          child: Container(
              color: Colors.black.withValues(alpha: widget.tintOpacity),
            padding: const EdgeInsets.all(48),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
