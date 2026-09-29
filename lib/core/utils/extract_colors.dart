import 'package:flutter/widgets.dart';
import 'package:palette_generator_plus/palette_generator_plus.dart';

final Map<String, List<Color>> _cache = {};

Future<List<Color>> extractColors(
  String url, {
  int count = 6,
  Color fallback = const Color(0xFF888888),
}) async {
  if (_cache.containsKey(url)) return _cache[url]!;

  try {
    final palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(url),
      size: const Size(200, 200),
    );

    final colors = palette.paletteColors
        .take(count)
        .map((pc) => pc.color)
        .toList();

    while (colors.length < count) {
      colors.add(fallback);
    }

    _cache[url] = colors;
    return colors;
  } catch (_) {
    return List.filled(count, fallback);
  }
}

void clearPaletteCache() => _cache.clear();
