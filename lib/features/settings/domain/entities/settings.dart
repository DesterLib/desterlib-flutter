// Features
import 'package:dester/features/settings/domain/entities/scan_settings.dart';

/// Settings entity representing application settings
class Settings {
  final String? tmdbApiKey;
  final bool firstRun;
  final ScanSettings? scanSettings;

  const Settings({this.tmdbApiKey, required this.firstRun, this.scanSettings});

  /// Check if a metadata provider is configured
  /// Currently checks for TMDB API key (the default metadata provider)
  /// In the future, this could check for any configured metadata provider
  bool get hasMetadataProvider {
    return tmdbApiKey != null && tmdbApiKey!.isNotEmpty;
  }
}
