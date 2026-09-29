import 'package:flutter/widgets.dart';
import 'package:desterlib_client/widgets/noise_widget.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF123C35), Color(0xFF2A6B5E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(child: NoiseOverlay(opacity: 0.05)),
        ),
        child,
      ],
    );
  }
}
