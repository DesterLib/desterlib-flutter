/// Shared utilities for media (Movie/TVShow) mappers
///
/// This class eliminates code duplication between MovieMapper and TVShowMapper
/// by providing common JSON parsing logic.
class MediaMapperUtils {
  /// Parse mesh gradient colors from JSON
  /// Returns list of exactly 6 colors, or null if invalid
  ///
  /// The mesh gradient requires exactly 6 color values (2x3 grid) to work properly.
  /// If the data doesn't contain exactly 6 valid colors, we return null
  /// rather than partially valid data.
  static List<String>? parseMeshGradientColors(dynamic json) {
    if (json == null) return null;

    if (json is! List) return null;

    final parsedColors = json
        .map((color) => color?.toString().trim())
        .whereType<String>()
        .where((color) => color.isNotEmpty)
        .toList();

    // Only use if we have exactly 6 colors
    return parsedColors.length == 6 ? parsedColors : null;
  }

  /// Parse createdAt date from JSON
  /// Handles both DateTime and String formats
  ///
  /// The API may return dates as DateTime objects or ISO 8601 strings.
  /// This method handles both cases gracefully.
  static DateTime? parseCreatedAt(dynamic json) {
    if (json == null) return null;

    if (json is DateTime) {
      return json;
    } else if (json is String) {
      return DateTime.tryParse(json);
    }

    return null;
  }

  /// Safely parse rating as double
  /// Handles both int and double numeric types
  static double? parseRating(dynamic json) {
    if (json == null) return null;
    return (json as num).toDouble();
  }

  /// Safely parse string value from JSON
  /// Converts any value to string, handles null
  static String? parseString(dynamic json) {
    return json?.toString();
  }

  /// Parse ISO date string and extract just the date portion
  /// Returns YYYY-MM-DD format
  static String? parseDateString(DateTime? dateTime) {
    return dateTime?.toIso8601String().split('T').first;
  }

  /// Parse genres from JSON
  /// Returns a list of genre names, or null if invalid
  static List<String>? parseGenres(dynamic json) {
    if (json == null) return null;

    if (json is! List) return null;

    final parsedGenres = json
        .map((genre) => genre?.toString().trim())
        .whereType<String>()
        .where((genre) => genre.isNotEmpty)
        .toList();

    return parsedGenres.isNotEmpty ? parsedGenres : null;
  }
}
