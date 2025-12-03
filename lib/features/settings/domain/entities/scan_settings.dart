/// Media type pattern configuration for movies
class MoviePatterns {
  final String? filenamePattern;
  final String? directoryPattern;

  const MoviePatterns({this.filenamePattern, this.directoryPattern});

  MoviePatterns copyWith({String? filenamePattern, String? directoryPattern}) {
    return MoviePatterns(
      filenamePattern: filenamePattern ?? this.filenamePattern,
      directoryPattern: directoryPattern ?? this.directoryPattern,
    );
  }
}

/// Media type pattern configuration for TV shows
class TvPatterns {
  final String? filenamePattern;
  final String? directoryPattern;

  const TvPatterns({this.filenamePattern, this.directoryPattern});

  TvPatterns copyWith({String? filenamePattern, String? directoryPattern}) {
    return TvPatterns(
      filenamePattern: filenamePattern ?? this.filenamePattern,
      directoryPattern: directoryPattern ?? this.directoryPattern,
    );
  }
}

/// Media-type-specific patterns
class MediaTypePatterns {
  final MoviePatterns? movie;
  final TvPatterns? tv;

  const MediaTypePatterns({this.movie, this.tv});

  MediaTypePatterns copyWith({MoviePatterns? movie, TvPatterns? tv}) {
    return MediaTypePatterns(movie: movie ?? this.movie, tv: tv ?? this.tv);
  }
}

/// Scan settings entity representing default scan configuration
class ScanSettings {
  final int? movieDepth;
  final int? tvDepth;
  final MediaTypePatterns? mediaTypePatterns;
  final bool? rescan;
  final bool? followSymlinks;

  /// Default scan settings
  static const ScanSettings defaults = ScanSettings(
    rescan: false,
    followSymlinks: true,
    movieDepth: 2,
    tvDepth: 4,
  );

  const ScanSettings({
    this.movieDepth,
    this.tvDepth,
    this.mediaTypePatterns,
    this.rescan,
    this.followSymlinks,
  });

  /// Create a copy with updated values
  ScanSettings copyWith({
    int? movieDepth,
    int? tvDepth,
    MediaTypePatterns? mediaTypePatterns,
    bool? rescan,
    bool? followSymlinks,
  }) {
    return ScanSettings(
      movieDepth: movieDepth ?? this.movieDepth,
      tvDepth: tvDepth ?? this.tvDepth,
      mediaTypePatterns: mediaTypePatterns ?? this.mediaTypePatterns,
      rescan: rescan ?? this.rescan,
      followSymlinks: followSymlinks ?? this.followSymlinks,
    );
  }

  /// Helper getters for media-type-specific patterns
  String? get movieFilenamePattern => mediaTypePatterns?.movie?.filenamePattern;
  String? get movieDirectoryPattern =>
      mediaTypePatterns?.movie?.directoryPattern;
  String? get tvFilenamePattern => mediaTypePatterns?.tv?.filenamePattern;
  String? get tvDirectoryPattern => mediaTypePatterns?.tv?.directoryPattern;
}
