// Dart
import 'dart:async';

// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/data/mappers/scan_settings_json_mapper.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_local_data_source_interface.dart';
import 'package:dester/features/settings/domain/services/settings_sync_service.dart';

/// Service for background synchronization with retry logic
abstract class SettingsBackgroundSyncService {
  /// Sync settings to server with retry logic
  /// Returns true if sync was successful, false otherwise
  Future<bool> syncToServerWithRetry({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  });

  /// Sync settings from server (pull)
  Future<Result<Settings>> syncFromServer();

  /// Start periodic background sync
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)});

  /// Stop periodic background sync
  void stopPeriodicSync();

  /// Check if there are pending changes to sync
  Future<bool> hasPendingSync();
}

/// Implementation of background sync service
class SettingsBackgroundSyncServiceImpl
    implements SettingsBackgroundSyncService {
  final SettingsSyncService _syncService;
  final SettingsLocalDataSourceInterface _localDataSource;
  Timer? _periodicSyncTimer;
  bool _isSyncing = false;

  SettingsBackgroundSyncServiceImpl({
    required SettingsSyncService syncService,
    required SettingsLocalDataSourceInterface localDataSource,
  }) : _syncService = syncService,
       _localDataSource = localDataSource;

  @override
  Future<bool> syncToServerWithRetry({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    if (_isSyncing) {
      AppLogger.d('Sync already in progress, skipping');
      return false;
    }

    _isSyncing = true;

    try {
      // Store pending sync before attempting
      final pendingData = <String, dynamic>{};
      if (tmdbApiKey != null) {
        pendingData['tmdbApiKey'] = tmdbApiKey;
      }
      if (scanSettings != null) {
        pendingData['scanSettings'] = _scanSettingsToMap(scanSettings);
      }

      await _localDataSource.setPendingSync(pendingData);

      // Retry logic with exponential backoff
      Duration delay = initialDelay;
      for (int attempt = 0; attempt < maxRetries; attempt++) {
        try {
          AppLogger.d(
            'Syncing settings to server (attempt ${attempt + 1}/$maxRetries)',
          );

          final result = await _syncService.syncToServer(
            tmdbApiKey: tmdbApiKey,
            scanSettings: scanSettings,
          );

          if (result.isSuccess) {
            AppLogger.d('Settings synced successfully');
            await _localDataSource.clearPendingSync();
            return true;
          }

          // If it's a network error and we have retries left, continue
          if (attempt < maxRetries - 1) {
            final failure = result.failureOrNull!;
            if (failure is NetworkFailure) {
              AppLogger.w(
                'Network error during sync, retrying in ${delay.inSeconds}s',
              );
              await Future.delayed(delay);
              delay = Duration(
                seconds: delay.inSeconds * 2,
              ); // Exponential backoff
              continue;
            }
          }

          // Non-retryable error or out of retries
          AppLogger.e('Failed to sync settings: ${result.failureOrNull}');
          return false;
        } catch (e) {
          AppLogger.e('Exception during sync attempt: $e');
          if (attempt < maxRetries - 1) {
            await Future.delayed(delay);
            delay = Duration(seconds: delay.inSeconds * 2);
          }
        }
      }

      AppLogger.w('Failed to sync after $maxRetries attempts');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  @override
  Future<Result<Settings>> syncFromServer() async {
    try {
      AppLogger.d('Syncing settings from server');
      final result = await _syncService.syncFromServer();
      if (result.isSuccess) {
        AppLogger.d('Settings synced from server successfully');
      } else {
        AppLogger.w('Failed to sync from server: ${result.failureOrNull}');
      }
      return result;
    } catch (e) {
      AppLogger.e('Exception syncing from server: $e');
      return ResultFailure(UnknownFailure('Failed to sync from server: $e'));
    }
  }

  @override
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}) {
    stopPeriodicSync(); // Stop any existing timer

    AppLogger.d('Starting periodic sync every ${interval.inMinutes} minutes');
    _periodicSyncTimer = Timer.periodic(interval, (_) async {
      // Sync from server (pull)
      await syncFromServer();

      // Sync pending changes to server (push)
      final hasPending = await hasPendingSync();
      if (hasPending) {
        final pendingResult = await _localDataSource.getPendingSync();
        if (pendingResult.isSuccess && pendingResult.dataOrNull != null) {
          final pending = pendingResult.dataOrNull!;
          await syncToServerWithRetry(
            tmdbApiKey: pending['tmdbApiKey'] as String?,
            scanSettings: pending['scanSettings'] != null
                ? _scanSettingsFromMap(
                    pending['scanSettings'] as Map<String, dynamic>,
                  )
                : null,
          );
        }
      }
    });
  }

  @override
  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    AppLogger.d('Stopped periodic sync');
  }

  @override
  Future<bool> hasPendingSync() async {
    final result = await _localDataSource.getPendingSync();
    return result.fold(
      onSuccess: (pending) => pending != null && pending.isNotEmpty,
      onFailure: (_) => false,
    );
  }

  /// Convert ScanSettings to map
  Map<String, dynamic> _scanSettingsToMap(ScanSettings settings) {
    return ScanSettingsJsonMapper.toJson(settings);
  }

  /// Convert map to ScanSettings
  ScanSettings? _scanSettingsFromMap(Map<String, dynamic>? map) {
    return ScanSettingsJsonMapper.fromJson(map);
  }
}
