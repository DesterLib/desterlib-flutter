import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sweepAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Single controller for all animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Sweep animation: 0-1800ms
    _sweepAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.72, curve: Curves.easeOut),
      ),
    );

    // Logo animation: synchronized with sweep
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.72, curve: Curves.easeOutBack),
      ),
    );

    // Fade out: last 500ms
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation and complete when done
    _controller.forward().then((_) {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Animated radial gradient background - pie chart style
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _sweepAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RadialSweepPainter(
                        progress: _sweepAnimation.value,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Logo in center with bounce animation
            Center(
              child: RepaintBoundary(
                child: ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadialSweepPainter extends CustomPainter {
  final double progress;

  // Cache the gradient colors as a constant - Apple-style palette
  static const _sweepColors = [
    Color(0xFF007AFF), // Apple Blue
    Color(0xFF5856D6), // Apple Purple
    Color(0xFFAF52DE), // Apple Violet
    Color(0xFFFF2D55), // Apple Pink/Red
    Color(0xFFFF3B30), // Apple Red
    Color(0xFF34C759), // Apple Green
    Color(0xFF00C7BE), // Apple Teal
    Color(0xFF007AFF), // Back to Apple Blue for smooth loop
  ];

  RadialSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Optimized radius calculation
    final radius = math.max(size.width, size.height) * 0.7;

    // Start angle at 180 degrees (bottom)
    const startAngle = math.pi;
    // Sweep angle based on progress (0 to 2*pi for full circle)
    final sweepAngle = progress * 2 * math.pi;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Single layer with combined gradients for best performance
    final combinedPaint = Paint()
      ..shader = SweepGradient(
        colors: _sweepColors,
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: const GradientRotation(math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawArc(rect, startAngle, sweepAngle, true, combinedPaint);
  }

  @override
  bool shouldRepaint(RadialSweepPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

  @override
  bool shouldRebuildSemantics(RadialSweepPainter oldDelegate) => false;
}
