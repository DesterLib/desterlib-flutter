import 'package:desterlib_client/core/app/app_background_state.dart';
import 'package:desterlib_client/widgets/noise_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class AppBackground extends StatefulWidget {
  const AppBackground({super.key, required this.state, required this.child});

  final AppBackgroundState state;
  final Widget child;

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  List<Color> _oldColors = AppBackgroundState.defaultColors;
  List<Color> _newColors = AppBackgroundState.defaultColors;

  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    widget.state.addListener(_onColorsChanged);
  }

  void _onColorsChanged() {
    _oldColors = _newColors;
    _newColors = widget.state.colors;

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    widget.state.removeListener(_onColorsChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final colors = _interpolateColors(
                _oldColors,
                _newColors,
                _animation.value,
              );

              return MeshGradient(
                points: [
                  MeshGradientPoint(
                    position: const Offset(0.0, 0.0),
                    color: colors[0],
                  ),
                  MeshGradientPoint(
                    position: const Offset(1.0, 0.0),
                    color: colors[1],
                  ),
                  MeshGradientPoint(
                    position: const Offset(0.0, 1.0),
                    color: colors[2],
                  ),
                  MeshGradientPoint(
                    position: const Offset(1.0, 1.0),
                    color: colors[3],
                  ),
                ],
                options: MeshGradientOptions(blend: 3, noiseIntensity: 0),
              );
            },
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(child: NoiseOverlay(opacity: 0.05)),
        ),
        widget.child,
      ],
    );
  }

  List<Color> _interpolateColors(List<Color> from, List<Color> to, double t) {
    final meshFrom = _meshColors(from);
    final meshTo = _meshColors(to);

    return [for (var i = 0; i < 4; i++) Color.lerp(meshFrom[i], meshTo[i], t)!];
  }

  List<Color> _meshColors(List<Color> colors) {
    if (colors.length == 1) {
      return List.filled(4, colors.first);
    }

    if (colors.length == 2) {
      return [colors[0], colors[1], colors[0], colors[1]];
    }

    if (colors.length == 3) {
      return [
        colors[0],
        colors[1],
        colors[2],
        Color.lerp(colors[1], colors[2], 0.5)!,
      ];
    }

    return [colors[0], colors[1], colors[colors.length ~/ 2], colors.last];
  }
}
