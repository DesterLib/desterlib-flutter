// External packages
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom loading pill with spring animation and color-changing gradient
///
/// Animation sequence:
/// 1. Start as 16x16 circle
/// 2. Spring animate to 24 pill
/// 3. On success: Shrink back to 24 pill
/// 4. Fade out
/// 5. Signal completion
class ConnectionLoadingPill extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  final bool isSuccess;

  const ConnectionLoadingPill({
    super.key,
    this.onAnimationComplete,
    this.isSuccess = false,
  });

  @override
  State<ConnectionLoadingPill> createState() => _ConnectionLoadingPillState();
}

class _ConnectionLoadingPillState extends State<ConnectionLoadingPill>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _shrinkController;
  late AnimationController _fadeController;
  late AnimationController _gradientController;

  late Animation<double> _widthAnimation;
  late Animation<double> _shrinkAnimation;
  late Animation<double> _fadeAnimation;

  bool _hasStartedSuccessAnimation = false;
  late DateTime _creationTime;

  @override
  void initState() {
    super.initState();

    // Track when widget was created for timing calculations
    _creationTime = DateTime.now();

    // Expand animation: 24 → 120 (dramatic spring curve)
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _widthAnimation = Tween<double>(begin: 24.0, end: 120.0).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: Curves.elasticOut, // Springy bounce on expand
      ),
    );

    // Shrink animation: 120 → 24 with dramatic elastic spring on WIDTH
    _shrinkController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shrinkAnimation = Tween<double>(begin: 120.0, end: 24.0).animate(
      CurvedAnimation(
        parent: _shrinkController,
        curve: const ElasticOutCurve(0.8), // More dramatic elastic bounce!
      ),
    );

    // Fade happens AFTER shrink completes (separate controller)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInCubic, // Smooth fade after collapse
      ),
    );

    // Gradient color cycling animation (continuous)
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Delay 500ms before starting expand animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _expandController.forward();
      }
    });

    // Listen for animation completion
    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ConnectionLoadingPill oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger success animation when isSuccess changes to true
    if (widget.isSuccess && !_hasStartedSuccessAnimation) {
      _hasStartedSuccessAnimation = true;
      _startSuccessAnimation();
    }
  }

  Future<void> _startSuccessAnimation() async {
    // 1. Wait for expand animation to complete if it's still running
    if (_expandController.status == AnimationStatus.forward ||
        _expandController.status == AnimationStatus.reverse) {
      await _expandController.forward();
    }

    if (!mounted) return;

    // 2. Ensure minimum 2000ms total display time from widget creation
    // This accounts for: 500ms delay + 1200ms expand + 300ms hold
    final minDisplayTime = 2000;
    final currentElapsed = DateTime.now()
        .difference(_creationTime)
        .inMilliseconds;
    final remainingTime = math.max(0, minDisplayTime - currentElapsed);

    if (remainingTime > 0) {
      await Future.delayed(Duration(milliseconds: remainingTime));
    }

    if (!mounted) return;

    // 3. Shrink back to circle with elastic spring (1000ms)
    await _shrinkController.forward();

    if (!mounted) return;

    // 4. Fade out AFTER collapse completes (400ms)
    await _fadeController.forward();
  }

  @override
  void dispose() {
    _expandController.dispose();
    _shrinkController.dispose();
    _fadeController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _expandController,
        _shrinkController,
        _fadeController,
        _gradientController,
      ]),
      builder: (context, child) {
        // Determine current width based on animation state
        double width;
        if (_shrinkController.status == AnimationStatus.forward ||
            _shrinkController.status == AnimationStatus.completed) {
          width = _shrinkAnimation.value;
        } else {
          width = _widthAnimation.value;
        }

        final opacity = _fadeAnimation.value;

        return Opacity(
          opacity: opacity,
          child: Container(
            width: width,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 3),
              gradient: _buildGradient(),
            ),
          ),
        );
      },
    );
  }

  /// Build color-changing gradient
  LinearGradient _buildGradient() {
    final progress = _gradientController.value;

    // Create a smooth color transition through hue spectrum
    final hue1 = (progress * 360) % 360;
    final hue2 = ((progress * 360) + 120) % 360;
    final hue3 = ((progress * 360) + 240) % 360;

    return LinearGradient(
      colors: [
        HSVColor.fromAHSV(1.0, hue1, 0.7, 0.9).toColor(),
        HSVColor.fromAHSV(1.0, hue2, 0.7, 0.9).toColor(),
        HSVColor.fromAHSV(1.0, hue3, 0.7, 0.9).toColor(),
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
