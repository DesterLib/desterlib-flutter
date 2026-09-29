import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';

class NoiseOverlay extends StatefulWidget {
  const NoiseOverlay({super.key, required this.opacity, this.tileSize = 256});

  final double opacity;
  final int tileSize;

  @override
  State<NoiseOverlay> createState() => _NoiseOverlayState();
}

class _NoiseOverlayState extends State<NoiseOverlay> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    final image = await _buildNoiseImage(widget.tileSize);
    if (!mounted) {
      image.dispose();
      return;
    }
    setState(() => _image = image);
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  static Future<ui.Image> _buildNoiseImage(int size) async {
    final random = Random(42);
    final pixels = Uint8List(size * size * 4);

    for (int i = 0; i < size * size; i++) {
      final v = random.nextInt(256);
      final offset = i * 4;
      pixels[offset] = v; // R
      pixels[offset + 1] = v; // G
      pixels[offset + 2] = v; // B
      pixels[offset + 3] = 255; // A
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      size,
      size,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    if (image == null) return const SizedBox.shrink();

    return IgnorePointer(
      child: CustomPaint(
        painter: _NoiseImagePainter(image: image, opacity: widget.opacity),
        size: Size.infinite,
      ),
    );
  }
}

class _NoiseImagePainter extends CustomPainter {
  _NoiseImagePainter({required this.image, required this.opacity});

  final ui.Image image;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      )
      ..color = Colors.white.withValues(alpha: opacity)
      ..blendMode = BlendMode.srcOver;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _NoiseImagePainter old) =>
      old.image != image || old.opacity != opacity;
}
