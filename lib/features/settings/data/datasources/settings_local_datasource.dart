// Dart
import 'dart:convert';

// External packages
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/storage/storage_keys.dart';

// Features
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';

// Features
import 'package:dester/features/settings/domain/repository/settings_local_data_source_interface.dart';

/// Local data source interface for settings persistence
/// Implements domain interface to maintain clean architecture
abstract class SettingsLocalDataSource
    implements SettingsLocalDataSourceInterface {
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

/// Implementation of local settings data source using SharedPreferences
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<Result<Settings?>> getCachedSettings() async {
    try {
      final jsonString = _prefs.getString(StorageKeys.settings);
      if (jsonString == null || jsonString.isEmpty) {
        return Success(null);
      }

      final Map<String, dynamic> json = jsonDecode(jsonString);
      return Success(_settingsFromJson(json));
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to read cached settings: $e'));
    }
  }

  @override
  Future<Result<void>> cacheSettings(Settings settings) async {
    try {
      final json = _settingsToJson(settings);
      final jsonString = jsonEncode(json);
      await _prefs.setString(StorageKeys.settings, jsonString);
      return Success(null);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to cache settings: $e'));
    }
  }

  @override
  Future<Result<DateTime?>> getLastSynced() async {
    try {
      final timestamp = _prefs.getInt(StorageKeys.settingsLastSynced);
      if (timestamp == null) {
        return Success(null);
      }
      return Success(DateTime.fromMillisecondsSinceEpoch(timestamp));
    } catch (e) {
      return ResultFailure(
        CacheFailure('Failed to read last synced timestamp: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setLastSynced(DateTime timestamp) async {
    try {
      await _prefs.setInt(
        StorageKeys.settingsLastSynced,
        timestamp.millisecondsSinceEpoch,
      );
      return Success(null);
    } catch (e) {
      return ResultFailure(
        CacheFailure('Failed to set last synced timestamp: $e'),
      );
    }
  }

  @override
  Future<Result<int>> getLocalVersion() async {
    try {
      final version = _prefs.getInt(StorageKeys.settingsLocalVersion) ?? 0;
      return Success(version);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to read local version: $e'));
    }
  }

  @override
  Future<Result<int>> incrementLocalVersion() async {
    try {
      final currentVersion = await getLocalVersion();
      return currentVersion.fold(
        onSuccess: (version) async {
          final newVersion = version + 1;
          await _prefs.setInt(StorageKeys.settingsLocalVersion, newVersion);
          return Success(newVersion);
        },
        onFailure: (failure) => ResultFailure(failure),
      );
    } catch (e) {
      return ResultFailure(
        CacheFailure('Failed to increment local version: $e'),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>?>> getPendingSync() async {
    try {
      final jsonString = _prefs.getString(StorageKeys.settingsPendingSync);
      if (jsonString == null || jsonString.isEmpty) {
        return Success(null);
      }
      return Success(jsonDecode(jsonString) as Map<String, dynamic>);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to read pending sync: $e'));
    }
  }

  @override
  Future<Result<void>> setPendingSync(Map<String, dynamic>? data) async {
    try {
      if (data == null) {
        await _prefs.remove(StorageKeys.settingsPendingSync);
      } else {
        final jsonString = jsonEncode(data);
        await _prefs.setString(StorageKeys.settingsPendingSync, jsonString);
      }
      return Success(null);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to set pending sync: $e'));
    }
  }

  @override
  Future<Result<void>> clearPendingSync() async {
    return await setPendingSync(null);
  }

  @override
  Future<Result<void>> clearCache() async {
    try {
      await _prefs.remove(StorageKeys.settings);
      await _prefs.remove(StorageKeys.settingsLastSynced);
      await _prefs.remove(StorageKeys.settingsLocalVersion);
      await _prefs.remove(StorageKeys.settingsPendingSync);
      return Success(null);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to clear cache: $e'));
    }
  }

  /// Convert Settings to JSON
  Map<String, dynamic> _settingsToJson(Settings settings) {
    return {
      'tmdbApiKey': settings.tmdbApiKey,
      'firstRun': settings.firstRun,
      'scanSettings': settings.scanSettings != null
          ? _scanSettingsToJson(settings.scanSettings!)
          : null,
    };
  }

  /// Convert JSON to Settings
  Settings _settingsFromJson(Map<String, dynamic> json) {
    return Settings(
      tmdbApiKey: json['tmdbApiKey'] as String?,
      firstRun: json['firstRun'] as bool? ?? true,
      scanSettings: json['scanSettings'] != null
          ? _scanSettingsFromJson(json['scanSettings'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert ScanSettings to JSON
  Map<String, dynamic> _scanSettingsToJson(ScanSettings settings) {
    return {
      'mediaType': settings.mediaType,
      'maxDepth': settings.maxDepth,
      'movieDepth': settings.movieDepth,
      'tvDepth': settings.tvDepth,
      'fileExtensions': settings.fileExtensions,
      'filenamePattern': settings.filenamePattern,
      'excludePattern': settings.excludePattern,
      'includePattern': settings.includePattern,
      'directoryPattern': settings.directoryPattern,
      'excludeDirectories': settings.excludeDirectories,
      'includeDirectories': settings.includeDirectories,
      'rescan': settings.rescan,
      'batchScan': settings.batchScan,
      'minFileSize': settings.minFileSize,
      'maxFileSize': settings.maxFileSize,
      'followSymlinks': settings.followSymlinks,
    };
  }

  /// Convert JSON to ScanSettings
  ScanSettings _scanSettingsFromJson(Map<String, dynamic> json) {
    return ScanSettings(
      mediaType: json['mediaType'] as String?,
      maxDepth: json['maxDepth'] as int?,
      movieDepth: json['movieDepth'] as int?,
      tvDepth: json['tvDepth'] as int?,
      fileExtensions: json['fileExtensions'] != null
          ? List<String>.from(json['fileExtensions'] as List)
          : null,
      filenamePattern: json['filenamePattern'] as String?,
      excludePattern: json['excludePattern'] as String?,
      includePattern: json['includePattern'] as String?,
      directoryPattern: json['directoryPattern'] as String?,
      excludeDirectories: json['excludeDirectories'] != null
          ? List<String>.from(json['excludeDirectories'] as List)
          : null,
      includeDirectories: json['includeDirectories'] != null
          ? List<String>.from(json['includeDirectories'] as List)
          : null,
      rescan: json['rescan'] as bool?,
      batchScan: json['batchScan'] as bool?,
      minFileSize: json['minFileSize'] as int?,
      maxFileSize: json['maxFileSize'] as int?,
      followSymlinks: json['followSymlinks'] as bool?,
    );
  }
}
