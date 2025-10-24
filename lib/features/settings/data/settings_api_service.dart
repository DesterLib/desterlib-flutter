import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../../core/config/api_config.dart';

class SettingsApiService {
  final ApiClient _apiClient;

  SettingsApiService(this._apiClient);

  /// Check if the API is reachable
  Future<bool> checkConnection() async {
    try {
      await _apiClient.get(ApiConfig.healthUrl);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get current settings from the API
  Future<Map<String, dynamic>> getSettings() async {
    final response = await _apiClient.get(ApiConfig.settingsUrl);
    return response['settings'] ?? {};
  }

  /// Update settings via the API
  Future<Map<String, dynamic>> updateSettings(
    Map<String, dynamic> settings,
  ) async {
    final response = await _apiClient.put(ApiConfig.settingsUrl, settings);
    return response['settings'] ?? {};
  }

  /// Update TMDB API key specifically
  Future<Map<String, dynamic>> updateTmdbApiKey(String apiKey) async {
    return updateSettings({'tmdbApiKey': apiKey});
  }
}

// Provider for settings API service
final settingsApiServiceProvider = Provider<SettingsApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SettingsApiService(apiClient);
});
