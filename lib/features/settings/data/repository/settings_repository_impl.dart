// Features
import 'package:dester/features/settings/data/datasources/settings_datasource.dart';
import 'package:dester/features/settings/data/mappers/settings_mapper.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';


/// Implementation of SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Settings> getSettings() async {
    final apiSettings = await dataSource.getSettings();
    return SettingsMapper.fromApiModel(apiSettings);
  }

  @override
  Future<Settings> updateSettings({String? tmdbApiKey}) async {
    final apiSettings = await dataSource.updateSettings(tmdbApiKey: tmdbApiKey);
    return SettingsMapper.fromApiModel(apiSettings);
  }
}
