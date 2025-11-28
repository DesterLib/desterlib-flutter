// External packages
import 'package:openapi/openapi.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';

/// Mapper for converting API models to domain entities
class SettingsMapper {
  /// Convert OpenAPI PublicSettings to domain Settings entity
  static Settings fromApiModel(PublicSettings? apiSettings) {
    if (apiSettings == null) {
      return const Settings(firstRun: true);
    }

    // Convert scanSettings from API model to domain entity
    ScanSettings? scanSettings;
    if (apiSettings.scanSettings != null) {
      scanSettings = _scanSettingsFromApi(apiSettings.scanSettings!);
    }

    return Settings(
      tmdbApiKey: apiSettings.tmdbApiKey,
      firstRun: apiSettings.firstRun ?? true,
      scanSettings: scanSettings,
    );
  }

  /// Convert PublicSettingsScanSettings to domain ScanSettings
  static ScanSettings _scanSettingsFromApi(
    PublicSettingsScanSettings apiScanSettings,
  ) {
    return ScanSettings(
      mediaType: apiScanSettings.mediaType?.name,
      maxDepth: apiScanSettings.maxDepth?.toInt(),
      movieDepth: apiScanSettings.mediaTypeDepth?.movie?.toInt(),
      tvDepth: apiScanSettings.mediaTypeDepth?.tv?.toInt(),
      fileExtensions: apiScanSettings.fileExtensions?.toList(),
      filenamePattern: apiScanSettings.filenamePattern,
      excludePattern: apiScanSettings.excludePattern,
      includePattern: apiScanSettings.includePattern,
      directoryPattern: apiScanSettings.directoryPattern,
      excludeDirectories: apiScanSettings.excludeDirectories?.toList(),
      includeDirectories: apiScanSettings.includeDirectories?.toList(),
      rescan: apiScanSettings.rescan,
      batchScan: apiScanSettings.batchScan,
      minFileSize: apiScanSettings.minFileSize?.toInt(),
      maxFileSize: apiScanSettings.maxFileSize?.toInt(),
      followSymlinks: apiScanSettings.followSymlinks,
    );
  }
}
