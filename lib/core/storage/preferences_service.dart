// Dart
import 'dart:convert';

// External packages
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/network/api_client_service.dart';

import 'storage_keys.dart';


/// Service for managing local preferences
class PreferencesService {
  static SharedPreferences? _prefs;

  /// Initialize the preferences service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get all API configurations
  static List<ApiConfiguration> getApiConfigurations() {
    final jsonString = _prefs?.getString(StorageKeys.apiConfigurations);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map(
            (json) => ApiConfiguration.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save all API configurations
  static Future<bool> saveApiConfigurations(
    List<ApiConfiguration> configurations,
  ) async {
    try {
      final jsonList = configurations.map((config) => config.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      final saved =
          await _prefs?.setString(StorageKeys.apiConfigurations, jsonString) ??
          false;

      if (saved) {
        // Update API client with active configuration
        ApiConfiguration? activeConfig;
        try {
          activeConfig = configurations.firstWhere((config) => config.isActive);
        } catch (e) {
          activeConfig = configurations.isNotEmpty
              ? configurations.first
              : null;
        }
        if (activeConfig != null) {
          ApiClientService.updateBaseUrl(activeConfig.url);
        }
      }

      return saved;
    } catch (e) {
      return false;
    }
  }

  /// Get the active API configuration
  static ApiConfiguration? getActiveApiConfiguration() {
    final configurations = getApiConfigurations();
    try {
      return configurations.firstWhere((config) => config.isActive);
    } catch (e) {
      return configurations.isNotEmpty ? configurations.first : null;
    }
  }

  /// Get the active API URL (for backward compatibility)
  static String? getActiveApiUrl() {
    final activeConfig = getActiveApiConfiguration();
    return activeConfig?.url;
  }
}
