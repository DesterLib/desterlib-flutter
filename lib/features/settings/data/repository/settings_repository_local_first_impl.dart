// Dart
import 'dart:async';

// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/data/datasources/settings_datasource.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_local_data_source_interface.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';
import 'package:dester/features/settings/domain/services/settings_background_sync_service.dart';

/// Local-first settings repository with caching and background sync
///
/// **Use this for production (DEFAULT):**
/// This is the recommended implementation for production use.
///
/// **Features:**
/// - Instant reads from local cache
/// - Optimistic updates (write to cache immediately)
/// - Background sync with retry logic
/// - Offline-first capabilities
/// - Conflict resolution
/// - Better user experience (no waiting for API)
///
/// **How it works:**
/// 1. **Read**: Returns cached data immediately, syncs in background
/// 2. **Write**: Updates cache immediately, syncs to server in background
/// 3. **Sync**: Automatic background synchronization with exponential backoff
///
/// **When NOT to use:**
/// - Legacy code requiring simple behavior (use [SettingsRepositoryImpl])
/// - Inside sync services (would create circular dependencies)
/// - Testing scenarios needing predictable behavior
///
/// See also: [SettingsRepositoryImpl] for simple implementation
class SettingsRepositoryLocalFirstImpl implements SettingsRepository {
  final SettingsDataSource _remoteDataSource;
  final SettingsLocalDataSourceInterface _localDataSource;
  final SettingsBackgroundSyncService _backgroundSyncService;

  SettingsRepositoryLocalFirstImpl({
    required SettingsDataSource remoteDataSource,
    required SettingsLocalDataSourceInterface localDataSource,
    required SettingsBackgroundSyncService backgroundSyncService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _backgroundSyncService = backgroundSyncService;

  @override
  Future<Result<Settings>> getSettings() async {
    // Local-first: Try cache first
    final cachedResult = await _localDataSource.getCachedSettings();

    if (cachedResult.isSuccess && cachedResult.dataOrNull != null) {
      // Return cached settings immediately
      final cached = cachedResult.dataOrNull!;

      // Sync from server in background (don't wait)
      _backgroundSyncService
          .syncFromServer()
          .then((result) {
            result.fold(
              onSuccess: (_) {
                AppLogger.d('Background sync from server completed');
              },
              onFailure: (failure) {
                AppLogger.w(
                  'Background sync from server failed: ${failure.message}',
                );
              },
            );
          })
          .catchError((error) {
            AppLogger.e('Exception during background sync: $error');
          });

      return Success(cached);
    }

    // No cache, fetch from server
    final remoteResult = await _remoteDataSource.getSettings();
    return remoteResult.fold(
      onSuccess: (settings) async {
        // Cache the settings
        await _localDataSource.cacheSettings(settings);
        await _localDataSource.setLastSynced(DateTime.now());
        return Success(settings);
      },
      onFailure: (failure) => ResultFailure(failure),
    );
  }

  @override
  Future<Result<Settings>> updateSettings({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    // Get current cached settings
    final cachedResult = await _localDataSource.getCachedSettings();
    final currentSettings = cachedResult.dataOrNull;

    // Update local cache immediately (optimistic update)
    Settings updatedSettings;
    if (currentSettings != null) {
      updatedSettings = Settings(
        tmdbApiKey: tmdbApiKey ?? currentSettings.tmdbApiKey,
        firstRun: currentSettings.firstRun,
        scanSettings: scanSettings ?? currentSettings.scanSettings,
      );
    } else {
      // No cached settings, create new
      updatedSettings = Settings(
        tmdbApiKey: tmdbApiKey,
        firstRun: true,
        scanSettings: scanSettings,
      );
    }

    // Cache immediately
    await _localDataSource.cacheSettings(updatedSettings);
    await _localDataSource.incrementLocalVersion();

    // Sync to server in background with retry
    _backgroundSyncService
        .syncToServerWithRetry(
          tmdbApiKey: tmdbApiKey,
          scanSettings: scanSettings,
        )
        .then((success) {
          if (success) {
            AppLogger.d('Background sync to server completed successfully');
          } else {
            AppLogger.w('Background sync to server failed, will retry later');
          }
        })
        .catchError((error) {
          AppLogger.e('Exception during background sync to server: $error');
        });

    // Return immediately with updated local settings
    return Success(updatedSettings);
  }

  @override
  Future<Result<Settings>> resetAllSettings() async {
    // Reset on server first (use resetScanSettings for now)
    final remoteResult = await _remoteDataSource.resetScanSettings();
    return remoteResult.fold(
      onSuccess: (settings) async {
        // Update local cache
        await _localDataSource.cacheSettings(settings);
        await _localDataSource.setLastSynced(DateTime.now());
        await _localDataSource.clearPendingSync();
        return Success(settings);
      },
      onFailure: (failure) => ResultFailure(failure),
    );
  }

  @override
  Future<Result<Settings>> resetScanSettings() async {
    // Reset on server first
    final remoteResult = await _remoteDataSource.resetScanSettings();
    return remoteResult.fold(
      onSuccess: (settings) async {
        // Update local cache
        await _localDataSource.cacheSettings(settings);
        await _localDataSource.setLastSynced(DateTime.now());
        await _localDataSource.clearPendingSync();
        return Success(settings);
      },
      onFailure: (failure) => ResultFailure(failure),
    );
  }
}
