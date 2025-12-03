import '../../network/models/settings_models.dart';
import '../../../features/settings/domain/entities/settings.dart';
import '../../../features/settings/domain/entities/scan_settings.dart';

/// Maps between API DTOs and domain entities for settings
class SettingsApiMapper {
  /// Convert SettingsDto to domain Settings entity
  static Settings toDomain(SettingsDto dto) {
    return Settings(
      tmdbApiKey: dto.tmdbApiKey,
      firstRun: dto.firstRun,
      scanSettings: dto.scanSettings != null
          ? _scanSettingsToDomain(dto.scanSettings!)
          : null,
    );
  }

  /// Convert domain ScanSettings to ScanSettingsDto
  static ScanSettingsDto scanSettingsToDto(ScanSettings settings) {
    return ScanSettingsDto(
      mediaTypeDepth: (settings.movieDepth != null || settings.tvDepth != null)
          ? MediaTypeDepthDto(movie: settings.movieDepth, tv: settings.tvDepth)
          : null,
      mediaTypePatterns: settings.mediaTypePatterns != null
          ? MediaTypePatternsDto(
              movie: settings.mediaTypePatterns!.movie != null
                  ? PatternConfigDto(
                      filenamePattern:
                          settings.mediaTypePatterns!.movie!.filenamePattern,
                      directoryPattern:
                          settings.mediaTypePatterns!.movie!.directoryPattern,
                    )
                  : null,
              tv: settings.mediaTypePatterns!.tv != null
                  ? PatternConfigDto(
                      filenamePattern:
                          settings.mediaTypePatterns!.tv!.filenamePattern,
                      directoryPattern:
                          settings.mediaTypePatterns!.tv!.directoryPattern,
                    )
                  : null,
            )
          : null,
      rescan: settings.rescan,
      followSymlinks: settings.followSymlinks,
    );
  }

  /// Convert ScanSettingsDto to domain ScanSettings entity
  static ScanSettings _scanSettingsToDomain(ScanSettingsDto dto) {
    return ScanSettings(
      movieDepth: dto.mediaTypeDepth?.movie,
      tvDepth: dto.mediaTypeDepth?.tv,
      mediaTypePatterns: dto.mediaTypePatterns != null
          ? MediaTypePatterns(
              movie: dto.mediaTypePatterns!.movie != null
                  ? MoviePatterns(
                      filenamePattern:
                          dto.mediaTypePatterns!.movie!.filenamePattern,
                      directoryPattern:
                          dto.mediaTypePatterns!.movie!.directoryPattern,
                    )
                  : null,
              tv: dto.mediaTypePatterns!.tv != null
                  ? TvPatterns(
                      filenamePattern:
                          dto.mediaTypePatterns!.tv!.filenamePattern,
                      directoryPattern:
                          dto.mediaTypePatterns!.tv!.directoryPattern,
                    )
                  : null,
            )
          : null,
      rescan: dto.rescan,
      followSymlinks: dto.followSymlinks,
    );
  }
}
