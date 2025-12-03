// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/data/datasources/settings_datasource.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';

/// Simple settings repository - direct pass-through to remote data source
///
/// **When to use this:**
/// - Legacy code that needs simple, direct API calls
/// - Inside sync services as a temporary repository (avoids circular dependencies)
/// - Testing scenarios that need predictable, non-cached behavior
/// - Debugging issues with local-first logic
///
/// **Characteristics:**
/// - No local caching
/// - Immediate server writes
/// - Synchronous behavior
/// - No background sync
///
/// **For production use, prefer:**
/// - `SettingsRepositoryLocalFirstImpl` - provides better UX with caching
///
/// See also: [SettingsRepositoryLocalFirstImpl] for local-first implementation
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Result<Settings>> getSettings() async {
    return await dataSource.getSettings();
  }

  @override
  Future<Result<Settings>> updateSettings({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    return await dataSource.updateSettings(
      tmdbApiKey: tmdbApiKey,
      scanSettings: scanSettings,
    );
  }

  @override
  Future<Result<Settings>> resetAllSettings() async {
    // Not implemented in API yet - could call multiple reset endpoints
    // For now, just reset scan settings
    return await dataSource.resetScanSettings();
  }

  @override
  Future<Result<Settings>> resetScanSettings() async {
    return await dataSource.resetScanSettings();
  }
}
