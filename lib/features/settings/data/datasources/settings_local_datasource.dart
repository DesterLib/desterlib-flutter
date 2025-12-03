// Dart
import 'dart:convert';

// External packages
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/storage/storage_keys.dart';

// Features
import 'package:dester/features/settings/data/mappers/scan_settings_json_mapper.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_local_data_source_interface.dart';

/// Implementation of local settings data source using SharedPreferences
class SettingsLocalDataSourceImpl implements SettingsLocalDataSourceInterface {
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
    return ScanSettingsJsonMapper.toJson(settings);
  }

  /// Convert JSON to ScanSettings
  ScanSettings _scanSettingsFromJson(Map<String, dynamic> json) {
    return ScanSettingsJsonMapper.fromJson(json)!;
  }
}
