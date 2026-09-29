import 'package:flutter/cupertino.dart';
import 'package:palette_generator_plus/palette_generator_plus.dart';

Future<List<Color>> extractColors(String imageUrl) async {
  final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
    NetworkImage(imageUrl),
    size: const Size(200, 200),
  );

  return palette.paletteColors
      .take(6)
      .map((paletteColor) => paletteColor.color)
      .toList();
}
