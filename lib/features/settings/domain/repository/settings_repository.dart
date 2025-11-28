// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';

/// Repository interface for settings operations
abstract class SettingsRepository {
  /// Get current settings
  Future<Result<Settings>> getSettings();

  /// Update settings
  Future<Result<Settings>> updateSettings({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  });

  /// Reset all settings to defaults
  Future<Result<Settings>> resetAllSettings();

  /// Reset scan settings to defaults
  Future<Result<Settings>> resetScanSettings();
}
