import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/api_config.dart';

class SettingsApiService {
  /// Check if the API is reachable
  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.healthUrl))
          .timeout(ApiConfig.timeout);
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  /// Get current settings from the API
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.settingsUrl))
          .timeout(ApiConfig.timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['settings'] ?? {};
      }
      throw Exception('Failed to get settings: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  /// Update settings via the API
  Future<Map<String, dynamic>> updateSettings(
    Map<String, dynamic> settings,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse(ApiConfig.settingsUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(settings),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['settings'] ?? {};
      }
      throw Exception('Failed to update settings: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  /// Update TMDB API key specifically
  Future<Map<String, dynamic>> updateTmdbApiKey(String apiKey) async {
    return updateSettings({'tmdbApiKey': apiKey});
  }
}

// Provider for settings API service
final settingsApiServiceProvider = Provider<SettingsApiService>((ref) {
  return SettingsApiService();
});
