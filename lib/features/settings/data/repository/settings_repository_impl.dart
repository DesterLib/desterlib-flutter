// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/data/datasources/settings_datasource.dart';
import 'package:dester/features/settings/data/mappers/settings_mapper.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';

/// Implementation of SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Result<Settings>> getSettings() async {
    final result = await dataSource.getSettings();
    return result.map(
      (apiSettings) => SettingsMapper.fromApiModel(apiSettings),
    );
  }

  @override
  Future<Result<Settings>> updateSettings({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    final result = await dataSource.updateSettings(
      tmdbApiKey: tmdbApiKey,
      scanSettings: scanSettings,
    );
    return result.map(
      (apiSettings) => SettingsMapper.fromApiModel(apiSettings),
    );
  }

  @override
  Future<Result<Settings>> resetAllSettings() async {
    final result = await dataSource.resetAllSettings();
    return result.map(
      (apiSettings) => SettingsMapper.fromApiModel(apiSettings),
    );
  }

  @override
  Future<Result<Settings>> resetScanSettings() async {
    final result = await dataSource.resetScanSettings();
    return result.map(
      (apiSettings) => SettingsMapper.fromApiModel(apiSettings),
    );
  }
}
