import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart' as mesh_gradient;

/// A widget that creates a mesh gradient effect using 4 corner colors
/// Wraps the mesh_gradient package to ensure compatibility with BackdropFilter blur effects
class MeshGradient extends StatelessWidget {
  final List<String> colors;
  final double height;

  const MeshGradient({super.key, required this.colors, required this.height});

  Color _parseColor(String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (colors.length != 4) {
      return const SizedBox.shrink();
    }

    final topLeft = _parseColor(colors[0]);
    final topRight = _parseColor(colors[1]);
    final bottomLeft = _parseColor(colors[2]);
    final bottomRight = _parseColor(colors[3]);

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Use the mesh_gradient package's MeshGradient widget
          // This uses a proper implementation that works with BackdropFilter
          // Place colors at the 4 corners: top-left, top-right, bottom-left, bottom-right
          Positioned.fill(
            child: mesh_gradient.MeshGradient(
              points: [
                mesh_gradient.MeshGradientPoint(
                  position: const Offset(0.0, 0.0), // Top-left
                  color: topLeft,
                ),
                mesh_gradient.MeshGradientPoint(
                  position: const Offset(1.0, 0.0), // Top-right
                  color: topRight,
                ),
                mesh_gradient.MeshGradientPoint(
                  position: const Offset(0.0, 1.0), // Bottom-left
                  color: bottomLeft,
                ),
                mesh_gradient.MeshGradientPoint(
                  position: const Offset(1.0, 1.0), // Bottom-right
                  color: bottomRight,
                ),
              ],
              options: mesh_gradient.MeshGradientOptions(),
            ),
          ),
          // Fade overlay from top to bottom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
