import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dester/core/utils/app_logger.dart';

/// Service for extracting dominant colors from images for mesh gradients
/// Replaces server-side color extraction with client-side processing
class ColorExtractor {
  // Cache to store extracted colors by image URL
  static final Map<String, List<String>> _colorCache = {};

  /// Extract 6 colors from an image URL for mesh gradient (2x3 grid)
  /// Returns list of 6 hex color strings, or null if extraction fails
  ///
  /// The colors represent a 2x3 grid:
  /// - Top-left, Top-center, Top-right
  /// - Bottom-left, Bottom-center, Bottom-right
  static Future<List<String>?> extractColorsFromUrl(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    // Check cache first
    if (_colorCache.containsKey(imageUrl)) {
      return _colorCache[imageUrl];
    }

    try {
      // Create image provider from URL
      final imageProvider = CachedNetworkImageProvider(imageUrl);

      // Generate palette from the image
      final paletteGenerator = await PaletteGeneratorMaster.fromImageProvider(
        imageProvider,
        maximumColorCount: 20, // Generate more colors for better selection
        colorSpace: ColorSpace.lab, // Use LAB color space for better accuracy
      );

      // Extract colors from the palette
      final paletteColors = paletteGenerator.paletteColors
          .map((paletteColor) => _colorToHex(paletteColor.color))
          .toList();

      // If we don't have enough colors, return null
      if (paletteColors.isEmpty) {
        AppLogger.w('Failed to extract colors from $imageUrl');
        return null;
      }

      // Ensure we have exactly 6 colors for the 2x3 mesh gradient
      final colors = <String>[];

      // Take up to 6 colors, or pad with the first color if needed
      for (int i = 0; i < 6; i++) {
        if (i < paletteColors.length) {
          colors.add(paletteColors[i]);
        } else {
          colors.add(paletteColors[0]); // Pad with first color
        }
      }

      // Cache the result
      _colorCache[imageUrl] = colors;

      AppLogger.d('Extracted colors from $imageUrl: $colors');
      return colors;
    } catch (e) {
      AppLogger.e('Error extracting colors from $imageUrl: $e');
      return null;
    }
  }

  /// Convert Flutter Color to hex string (without # prefix)
  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8)}';
  }

  /// Clear the color cache (useful for memory management)
  static void clearCache() {
    _colorCache.clear();
  }

  /// Remove a specific URL from cache
  static void removeCachedColor(String imageUrl) {
    _colorCache.remove(imageUrl);
  }

  /// Check if a color is cached
  static bool isCached(String imageUrl) {
    return _colorCache.containsKey(imageUrl);
  }

  /// Get cached colors synchronously (returns null if not cached)
  /// Use this when you need colors immediately without triggering extraction
  static List<String>? getCachedColors(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    return _colorCache[imageUrl];
  }

  /// Get cache size
  static int getCacheSize() {
    return _colorCache.length;
  }
}
