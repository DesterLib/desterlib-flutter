// Dart
import 'dart:async';

// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_local_data_source_interface.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';

/// Service for handling settings synchronization with conflict resolution
abstract class SettingsSyncService {
  /// Sync settings from server to local (pull)
  /// Merges with local changes, resolving conflicts
  Future<Result<Settings>> syncFromServer();

  /// Sync local changes to server (push)
  /// Uses pending sync data if available
  Future<Result<void>> syncToServer({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  });

  /// Merge server settings with local settings, resolving conflicts
  /// Local changes that haven't synced take precedence
  Future<Result<Settings>> mergeSettings({
    required Settings serverSettings,
    required Settings localSettings,
    required DateTime? lastSynced,
    required Map<String, dynamic>? pendingSync,
  });
}

/// Implementation of settings sync service
class SettingsSyncServiceImpl implements SettingsSyncService {
  final SettingsRepository _repository;
  final SettingsLocalDataSourceInterface _localDataSource;

  SettingsSyncServiceImpl({
    required SettingsRepository repository,
    required SettingsLocalDataSourceInterface localDataSource,
  }) : _repository = repository,
       _localDataSource = localDataSource;

  @override
  Future<Result<Settings>> syncFromServer() async {
    try {
      // Get server settings
      final serverResult = await _repository.getSettings();
      return serverResult.fold(
        onSuccess: (serverSettings) async {
          // Get local settings
          final localResult = await _localDataSource.getCachedSettings();
          return localResult.fold(
            onSuccess: (localSettings) async {
              // If no local settings, just cache server settings
              if (localSettings == null) {
                await _localDataSource.cacheSettings(serverSettings);
                await _localDataSource.setLastSynced(DateTime.now());
                return Success(serverSettings);
              }

              // Get sync metadata
              final lastSyncedResult = await _localDataSource.getLastSynced();
              final pendingSyncResult = await _localDataSource.getPendingSync();

              if (lastSyncedResult.isFailure || pendingSyncResult.isFailure) {
                return ResultFailure(
                  lastSyncedResult.failureOrNull ??
                      pendingSyncResult.failureOrNull!,
                );
              }

              // Merge settings (local changes take precedence if not synced)
              final mergedResult = await mergeSettings(
                serverSettings: serverSettings,
                localSettings: localSettings,
                lastSynced: lastSyncedResult.dataOrNull,
                pendingSync: pendingSyncResult.dataOrNull,
              );

              return mergedResult.fold(
                onSuccess: (mergedSettings) async {
                  // Cache merged settings
                  await _localDataSource.cacheSettings(mergedSettings);
                  await _localDataSource.setLastSynced(DateTime.now());
                  return Success(mergedSettings);
                },
                onFailure: (failure) => ResultFailure(failure),
              );
            },
            onFailure: (failure) => ResultFailure(failure),
          );
        },
        onFailure: (failure) => ResultFailure(failure),
      );
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to sync from server: $e'));
    }
  }

  @override
  Future<Result<void>> syncToServer({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    try {
      // Update server
      final updateResult = await _repository.updateSettings(
        tmdbApiKey: tmdbApiKey,
        scanSettings: scanSettings,
      );

      return updateResult.fold(
        onSuccess: (updatedSettings) async {
          // Update local cache with server response
          await _localDataSource.cacheSettings(updatedSettings);
          await _localDataSource.setLastSynced(DateTime.now());

          // Clear pending sync if we have one
          final pendingSyncResult = await _localDataSource.getPendingSync();
          if (pendingSyncResult.isSuccess &&
              pendingSyncResult.dataOrNull != null) {
            // Check if pending sync matches what we just sent
            final pending = pendingSyncResult.dataOrNull!;
            bool matches = true;

            if (tmdbApiKey != null && pending['tmdbApiKey'] != tmdbApiKey) {
              matches = false;
            }
            if (scanSettings != null && pending['scanSettings'] != null) {
              // Simple check - in production, do deep comparison
              matches = false; // Assume different for safety
            }

            if (matches) {
              await _localDataSource.clearPendingSync();
            }
          }

          return Success(null);
        },
        onFailure: (failure) => ResultFailure(failure),
      );
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to sync to server: $e'));
    }
  }

  @override
  Future<Result<Settings>> mergeSettings({
    required Settings serverSettings,
    required Settings localSettings,
    required DateTime? lastSynced,
    required Map<String, dynamic>? pendingSync,
  }) async {
    try {
      // If there are pending local changes, they take precedence
      if (pendingSync != null && pendingSync.isNotEmpty) {
        // Merge pending changes with server settings
        // Pending changes override server values
        final merged = Settings(
          tmdbApiKey:
              pendingSync['tmdbApiKey'] as String? ?? serverSettings.tmdbApiKey,
          firstRun: serverSettings.firstRun, // Server controls firstRun
          scanSettings: _mergeScanSettings(
            server: serverSettings.scanSettings,
            pending: pendingSync['scanSettings'] != null
                ? _scanSettingsFromMap(
                    pendingSync['scanSettings'] as Map<String, dynamic>,
                  )
                : null,
          ),
        );
        return Success(merged);
      }

      // If local was modified after last sync, keep local changes
      // Otherwise, use server settings
      // For now, we'll use server settings if no pending sync
      // In production, you might want to compare timestamps more carefully
      return Success(serverSettings);
    } catch (e) {
      return ResultFailure(UnknownFailure('Failed to merge settings: $e'));
    }
  }

  /// Merge scan settings, with pending taking precedence
  ScanSettings? _mergeScanSettings({
    ScanSettings? server,
    ScanSettings? pending,
  }) {
    if (pending != null) {
      return pending; // Pending changes take full precedence
    }
    return server;
  }

  /// Convert map to ScanSettings (helper)
  ScanSettings? _scanSettingsFromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    // Parse mediaTypePatterns if present
    MediaTypePatterns? mediaTypePatterns;
    if (map['mediaTypePatterns'] != null) {
      final patternsMap = map['mediaTypePatterns'] as Map<String, dynamic>;
      mediaTypePatterns = MediaTypePatterns(
        movie: patternsMap['movie'] != null
            ? MoviePatterns(
                filenamePattern:
                    patternsMap['movie']['filenamePattern'] as String?,
                directoryPattern:
                    patternsMap['movie']['directoryPattern'] as String?,
              )
            : null,
        tv: patternsMap['tv'] != null
            ? TvPatterns(
                filenamePattern:
                    patternsMap['tv']['filenamePattern'] as String?,
                directoryPattern:
                    patternsMap['tv']['directoryPattern'] as String?,
              )
            : null,
      );
    }

    return ScanSettings(
      movieDepth: map['movieDepth'] as int?,
      tvDepth: map['tvDepth'] as int?,
      mediaTypePatterns: mediaTypePatterns,
      rescan: map['rescan'] as bool?,
      followSymlinks: map['followSymlinks'] as bool?,
    );
  }
}
