// Features
import 'package:dester/features/settings/domain/entities/scan_settings.dart';

/// Mapper for ScanSettings JSON serialization
///
/// This class eliminates code duplication between:
/// - SettingsLocalDataSourceImpl (local storage)
/// - SettingsBackgroundSyncServiceImpl (background sync)
///
/// Used for converting ScanSettings to/from JSON for local storage
/// and background synchronization operations.
class ScanSettingsJsonMapper {
  /// Convert ScanSettings to JSON map
  ///
  /// Serializes a ScanSettings entity into a JSON-compatible map
  /// that can be stored in SharedPreferences or sent over the network.
  ///
  /// Example:
  /// ```dart
  /// final settings = ScanSettings(movieDepth: 2, tvDepth: 4);
  /// final json = ScanSettingsJsonMapper.toJson(settings);
  /// // Returns: {'movieDepth': 2, 'tvDepth': 4, ...}
  /// ```
  static Map<String, dynamic> toJson(ScanSettings settings) {
    return {
      'movieDepth': settings.movieDepth,
      'tvDepth': settings.tvDepth,
      'mediaTypePatterns': settings.mediaTypePatterns != null
          ? _mediaTypePatternsToJson(settings.mediaTypePatterns!)
          : null,
      'rescan': settings.rescan,
      'followSymlinks': settings.followSymlinks,
    };
  }

  /// Convert JSON map to ScanSettings
  ///
  /// Deserializes a JSON map back into a ScanSettings entity.
  /// Returns null if the input map is null.
  ///
  /// Example:
  /// ```dart
  /// final json = {'movieDepth': 2, 'tvDepth': 4};
  /// final settings = ScanSettingsJsonMapper.fromJson(json);
  /// // Returns: ScanSettings(movieDepth: 2, tvDepth: 4)
  /// ```
  static ScanSettings? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    // Parse mediaTypePatterns if present
    MediaTypePatterns? mediaTypePatterns;
    if (json['mediaTypePatterns'] != null) {
      mediaTypePatterns = _mediaTypePatternsFromJson(
        json['mediaTypePatterns'] as Map<String, dynamic>,
      );
    }

    return ScanSettings(
      movieDepth: json['movieDepth'] as int?,
      tvDepth: json['tvDepth'] as int?,
      mediaTypePatterns: mediaTypePatterns,
      rescan: json['rescan'] as bool?,
      followSymlinks: json['followSymlinks'] as bool?,
    );
  }

  /// Convert MediaTypePatterns to JSON
  static Map<String, dynamic> _mediaTypePatternsToJson(
    MediaTypePatterns patterns,
  ) {
    return {
      'movie': patterns.movie != null
          ? _moviePatternsToJson(patterns.movie!)
          : null,
      'tv': patterns.tv != null ? _tvPatternsToJson(patterns.tv!) : null,
    };
  }

  /// Convert JSON to MediaTypePatterns
  static MediaTypePatterns _mediaTypePatternsFromJson(
    Map<String, dynamic> json,
  ) {
    return MediaTypePatterns(
      movie: json['movie'] != null
          ? _moviePatternsFromJson(json['movie'] as Map<String, dynamic>)
          : null,
      tv: json['tv'] != null
          ? _tvPatternsFromJson(json['tv'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert MoviePatterns to JSON
  static Map<String, dynamic> _moviePatternsToJson(MoviePatterns patterns) {
    return {
      'filenamePattern': patterns.filenamePattern,
      'directoryPattern': patterns.directoryPattern,
    };
  }

  /// Convert JSON to MoviePatterns
  static MoviePatterns _moviePatternsFromJson(Map<String, dynamic> json) {
    return MoviePatterns(
      filenamePattern: json['filenamePattern'] as String?,
      directoryPattern: json['directoryPattern'] as String?,
    );
  }

  /// Convert TvPatterns to JSON
  static Map<String, dynamic> _tvPatternsToJson(TvPatterns patterns) {
    return {
      'filenamePattern': patterns.filenamePattern,
      'directoryPattern': patterns.directoryPattern,
    };
  }

  /// Convert JSON to TvPatterns
  static TvPatterns _tvPatternsFromJson(Map<String, dynamic> json) {
    return TvPatterns(
      filenamePattern: json['filenamePattern'] as String?,
      directoryPattern: json['directoryPattern'] as String?,
    );
  }
}
