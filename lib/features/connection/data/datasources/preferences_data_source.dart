import '../../../../core/storage/preferences_service.dart';

/// Data source for preferences storage
abstract class PreferencesDataSource {
  Future<String?> getApiBaseUrl();
  Future<bool> setApiBaseUrl(String url);
  Future<bool> clearApiBaseUrl();
}

/// Implementation of preferences data source
class PreferencesDataSourceImpl implements PreferencesDataSource {
  @override
  Future<String?> getApiBaseUrl() async {
    return PreferencesService.getApiBaseUrl();
  }

  @override
  Future<bool> setApiBaseUrl(String url) async {
    return PreferencesService.setApiBaseUrl(url);
  }

  @override
  Future<bool> clearApiBaseUrl() async {
    return PreferencesService.clearApiBaseUrl();
  }
}
