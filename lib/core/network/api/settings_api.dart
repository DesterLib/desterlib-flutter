import '../api_client.dart';
import '../models/api_response.dart';
import '../models/settings_models.dart';

/// Settings API endpoints
class SettingsApi {
  final ApiClient _client;

  SettingsApi(this._client);

  /// Get application settings
  Future<SettingsDto> getSettings({bool includePrivate = false}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/settings',
      queryParameters: {'includePrivate': includePrivate},
    );

    final apiResponse = ApiResponse<SettingsDto>.fromJson(
      response.data!,
      (json) => SettingsDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get settings');
    }

    return apiResponse.data!;
  }

  /// Update application settings
  Future<SettingsDto> updateSettings(UpdateSettingsRequestDto request) async {
    final response = await _client.put<Map<String, dynamic>>(
      '/api/v1/settings',
      data: request.toJson(),
    );

    final apiResponse = ApiResponse<SettingsDto>.fromJson(
      response.data!,
      (json) => SettingsDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to update settings');
    }

    return apiResponse.data!;
  }

  /// Complete first run setup
  Future<void> completeFirstRun() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/settings/first-run/complete',
    );

    final apiResponse = ApiResponse<dynamic>.fromJson(
      response.data!,
      (json) => json,
    );

    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to complete first run');
    }
  }

  /// Reset scan settings to defaults
  Future<SettingsDto> resetScanSettings() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/settings/scan/reset',
    );

    final apiResponse = ApiResponse<SettingsDto>.fromJson(
      response.data!,
      (json) => SettingsDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to reset scan settings');
    }

    return apiResponse.data!;
  }
}
