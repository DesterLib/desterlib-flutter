import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Logo animations
          final fadeIn = _controller.value.clamp(0.0, 0.3) / 0.3;
          final scaleUp = Curves.easeOutBack.transform(
            (_controller.value.clamp(0.0, 0.5) / 0.5),
          );

          return CustomPaint(
            painter: RadialSweepPainter(progress: _controller.value),
            child: Center(
              child: Opacity(
                opacity: fadeIn,
                child: Transform.scale(
                  scale: 0.5 + (scaleUp * 0.5),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/icon/icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RadialSweepPainter extends CustomPainter {
  final double progress;
  RadialSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.longestSide; // Fill the entire screen

    // Start with full circle (2π), sweep clockwise to nothing (0)
    final sweepAngle = (1 - progress) * 2 * pi;

    // Start edge moves clockwise, sweeping away the circle
    final startAngle = progress * 2 * pi;

    // Cyan, Green, Blue, Purple gradient
    const cyan = Color(0xFF00E5FF);
    const green = Color(0xFF00E676);
    const blue = Color(0xFF2979FF);
    const purple = Color(0xFF651FFF);

    // Rotate gradient with the sweep so colors move clockwise
    // The gradient should rotate at the same rate as the startAngle
    final gradientRotation = startAngle;

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: [
        Colors.transparent,
        cyan.withValues(alpha: 0.2),
        cyan.withValues(alpha: 0.5),
        cyan.withValues(alpha: 0.8),
        cyan,
        green,
        blue,
        purple,
        purple.withValues(alpha: 0.8),
        purple.withValues(alpha: 0.5),
        purple.withValues(alpha: 0.2),
        Colors.transparent,
      ],
      stops: const [
        0.0,
        0.03,
        0.06,
        0.09,
        0.12,
        0.35,
        0.58,
        0.75,
        0.85,
        0.92,
        0.97,
        1.0,
      ],
      transform: GradientRotation(gradientRotation),
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw sweeping slice (only if there's something to draw)
    if (sweepAngle > 0) {
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RadialSweepPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
