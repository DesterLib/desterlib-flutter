import 'dart:math';
import 'package:flutter/material.dart';

/// Generates a deterministic mesh gradient from a genre name
class GenreColorGenerator {
  /// Generates 4 colors for mesh gradient based on genre name
  static List<Color> generateMeshColors(String genreName) {
    // Generate deterministic seed from genre name
    final seed = _hashString(genreName);
    final random = Random(seed);

    // Generate base hue (0-360)
    final baseHue = random.nextDouble() * 360;

    // Generate 4 colors with similar frequencies for mesh gradient
    final colors = <Color>[];

    for (int i = 0; i < 4; i++) {
      // Vary hue slightly (±40 degrees) for similar color family
      final hueVariation = (random.nextDouble() - 0.5) * 80;
      final hue = (baseHue + hueVariation) % 360;

      // Vary saturation (55-85%)
      final saturation = 0.55 + random.nextDouble() * 0.3;

      // Vary lightness (45-75%) for depth and blend
      final lightness = 0.45 + random.nextDouble() * 0.3;

      colors.add(HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor());
    }

    return colors;
  }

  /// Generates a text color that blends well with the gradient
  static Color generateTextColor(String genreName) {
    final colors = generateMeshColors(genreName);

    // Calculate average brightness
    double totalBrightness = 0;
    for (final color in colors) {
      final hsl = HSLColor.fromColor(color);
      totalBrightness += hsl.lightness;
    }
    final avgBrightness = totalBrightness / colors.length;

    // Return semi-transparent white that blends with the background
    // Adjust opacity based on background brightness
    if (avgBrightness > 0.65) {
      // Light background - more transparent
      return Colors.white.withValues(alpha: 0.75);
    } else if (avgBrightness > 0.55) {
      // Medium background
      return Colors.white.withValues(alpha: 0.85);
    } else {
      // Dark background - more opaque
      return Colors.white.withValues(alpha: 0.92);
    }
  }

  /// Hash a string to generate a consistent integer seed
  static int _hashString(String str) {
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash) + str.codeUnitAt(i);
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.abs();
  }
}
