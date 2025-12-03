/// Public settings response (excludes sensitive data)
class SettingsDto {
  final String? tmdbApiKey;
  final int port;
  final bool enableRouteGuards;
  final bool firstRun;
  final ScanSettingsDto? scanSettings;

  const SettingsDto({
    this.tmdbApiKey,
    required this.port,
    required this.enableRouteGuards,
    required this.firstRun,
    this.scanSettings,
  });

  factory SettingsDto.fromJson(Map<String, dynamic> json) {
    return SettingsDto(
      tmdbApiKey: json['tmdbApiKey'] as String?,
      port: json['port'] as int,
      enableRouteGuards: json['enableRouteGuards'] as bool,
      firstRun: json['firstRun'] as bool,
      scanSettings: json['scanSettings'] != null
          ? ScanSettingsDto.fromJson(
              json['scanSettings'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Scan settings configuration
class ScanSettingsDto {
  final MediaTypeDepthDto? mediaTypeDepth;
  final MediaTypePatternsDto? mediaTypePatterns;
  final bool? rescan;
  final bool? followSymlinks;

  const ScanSettingsDto({
    this.mediaTypeDepth,
    this.mediaTypePatterns,
    this.rescan,
    this.followSymlinks,
  });

  factory ScanSettingsDto.fromJson(Map<String, dynamic> json) {
    return ScanSettingsDto(
      mediaTypeDepth: json['mediaTypeDepth'] != null
          ? MediaTypeDepthDto.fromJson(
              json['mediaTypeDepth'] as Map<String, dynamic>,
            )
          : null,
      mediaTypePatterns: json['mediaTypePatterns'] != null
          ? MediaTypePatternsDto.fromJson(
              json['mediaTypePatterns'] as Map<String, dynamic>,
            )
          : null,
      rescan: json['rescan'] as bool?,
      followSymlinks: json['followSymlinks'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (mediaTypeDepth != null) {
      json['mediaTypeDepth'] = mediaTypeDepth!.toJson();
    }
    if (mediaTypePatterns != null) {
      json['mediaTypePatterns'] = mediaTypePatterns!.toJson();
    }
    if (rescan != null) json['rescan'] = rescan;
    if (followSymlinks != null) json['followSymlinks'] = followSymlinks;
    return json;
  }
}

/// Media type specific depth configuration
class MediaTypeDepthDto {
  final int? movie;
  final int? tv;

  const MediaTypeDepthDto({this.movie, this.tv});

  factory MediaTypeDepthDto.fromJson(Map<String, dynamic> json) {
    return MediaTypeDepthDto(
      movie: json['movie'] as int?,
      tv: json['tv'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (movie != null) json['movie'] = movie;
    if (tv != null) json['tv'] = tv;
    return json;
  }
}

/// Media type specific patterns
class MediaTypePatternsDto {
  final PatternConfigDto? movie;
  final PatternConfigDto? tv;

  const MediaTypePatternsDto({this.movie, this.tv});

  factory MediaTypePatternsDto.fromJson(Map<String, dynamic> json) {
    return MediaTypePatternsDto(
      movie: json['movie'] != null
          ? PatternConfigDto.fromJson(json['movie'] as Map<String, dynamic>)
          : null,
      tv: json['tv'] != null
          ? PatternConfigDto.fromJson(json['tv'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (movie != null) json['movie'] = movie!.toJson();
    if (tv != null) json['tv'] = tv!.toJson();
    return json;
  }
}

/// Pattern configuration (filename and directory)
class PatternConfigDto {
  final String? filenamePattern;
  final String? directoryPattern;

  const PatternConfigDto({this.filenamePattern, this.directoryPattern});

  factory PatternConfigDto.fromJson(Map<String, dynamic> json) {
    return PatternConfigDto(
      filenamePattern: json['filenamePattern'] as String?,
      directoryPattern: json['directoryPattern'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (filenamePattern != null) json['filenamePattern'] = filenamePattern;
    if (directoryPattern != null) json['directoryPattern'] = directoryPattern;
    return json;
  }
}

/// Update settings request
class UpdateSettingsRequestDto {
  final String? tmdbApiKey;
  final int? port;
  final bool? enableRouteGuards;
  final bool? firstRun;
  final ScanSettingsDto? scanSettings;

  const UpdateSettingsRequestDto({
    this.tmdbApiKey,
    this.port,
    this.enableRouteGuards,
    this.firstRun,
    this.scanSettings,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (tmdbApiKey != null) {
      json['tmdbApiKey'] = tmdbApiKey;
    }
    if (port != null) {
      json['port'] = port;
    }
    if (enableRouteGuards != null) {
      json['enableRouteGuards'] = enableRouteGuards;
    }
    if (firstRun != null) {
      json['firstRun'] = firstRun;
    }
    if (scanSettings != null) {
      json['scanSettings'] = scanSettings!.toJson();
    }
    return json;
  }
}
