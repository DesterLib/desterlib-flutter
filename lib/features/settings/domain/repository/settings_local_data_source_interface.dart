// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';

/// Domain interface for local settings data source
/// This interface belongs in domain layer to avoid clean architecture violations
abstract class SettingsLocalDataSourceInterface {
  /// Get cached settings from local storage
  Future<Result<Settings?>> getCachedSettings();

  /// Cache settings to local storage
  Future<Result<void>> cacheSettings(Settings settings);

  /// Get last sync timestamp
  Future<Result<DateTime?>> getLastSynced();

  /// Set last sync timestamp
  Future<Result<void>> setLastSynced(DateTime timestamp);

  /// Get local version (increments on each local change)
  Future<Result<int>> getLocalVersion();

  /// Increment local version
  Future<Result<int>> incrementLocalVersion();

  /// Get pending sync data (local changes not yet synced)
  Future<Result<Map<String, dynamic>?>> getPendingSync();

  /// Set pending sync data
  Future<Result<void>> setPendingSync(Map<String, dynamic>? data);

  /// Clear pending sync data
  Future<Result<void>> clearPendingSync();

  /// Clear all cached settings
  Future<Result<void>> clearCache();
}
