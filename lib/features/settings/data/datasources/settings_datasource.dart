// External packages
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

// Core
import 'package:dester/core/network/api_client_service.dart';
import 'package:dester/core/utils/app_logger.dart';


/// Data source for settings operations
class SettingsDataSource {
  /// Get current settings from the API
  Future<PublicSettings?> getSettings() async {
    try {
      final client = ApiClientService.getClient();
      final settingsApi = client.getSettingsApi();

      final response = await settingsApi.apiV1SettingsGet();

      if (response.data?.success == true && response.data?.data != null) {
        return response.data!.data;
      }

      AppLogger.w('Settings response missing data');
      return null;
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch settings: ${e.message}', e);
      throw Exception('Failed to fetch settings: ${e.message}');
    } catch (e) {
      AppLogger.e('Failed to fetch settings: $e', e);
      throw Exception('Failed to fetch settings: $e');
    }
  }

  /// Update settings via API
  Future<PublicSettings?> updateSettings({String? tmdbApiKey}) async {
    try {
      final client = ApiClientService.getClient();
      final settingsApi = client.getSettingsApi();

      final request = UpdateSettingsRequest((b) => b..tmdbApiKey = tmdbApiKey);

      final response = await settingsApi.apiV1SettingsPut(
        updateSettingsRequest: request,
      );

      if (response.data?.success == true && response.data?.data != null) {
        return response.data!.data;
      }

      AppLogger.w('Settings update response missing data');
      return null;
    } on DioException catch (e) {
      AppLogger.e('Failed to update settings: ${e.message}', e);
      throw Exception('Failed to update settings: ${e.message}');
    } catch (e) {
      AppLogger.e('Failed to update settings: $e', e);
      throw Exception('Failed to update settings: $e');
    }
  }
}
