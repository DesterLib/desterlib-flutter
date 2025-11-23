// Core
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/storage/preferences_service.dart';


/// Data source for preferences storage
abstract class PreferencesDataSource {
  List<ApiConfiguration> getApiConfigurations();
  Future<bool> saveApiConfigurations(List<ApiConfiguration> configurations);
  ApiConfiguration? getActiveApiConfiguration();
}

/// Implementation of preferences data source
class PreferencesDataSourceImpl implements PreferencesDataSource {
  @override
  List<ApiConfiguration> getApiConfigurations() {
    return PreferencesService.getApiConfigurations();
  }

  @override
  Future<bool> saveApiConfigurations(
    List<ApiConfiguration> configurations,
  ) async {
    return PreferencesService.saveApiConfigurations(configurations);
  }

  @override
  ApiConfiguration? getActiveApiConfiguration() {
    return PreferencesService.getActiveApiConfiguration();
  }
}
