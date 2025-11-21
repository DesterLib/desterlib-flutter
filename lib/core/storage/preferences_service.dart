import 'package:shared_preferences/shared_preferences.dart';
import 'storage_keys.dart';

/// Service for managing local preferences
class PreferencesService {
  static SharedPreferences? _prefs;

  /// Initialize the preferences service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get the stored API base URL
  static String? getApiBaseUrl() {
    return _prefs?.getString(StorageKeys.apiBaseUrl);
  }

  /// Set the API base URL
  static Future<bool> setApiBaseUrl(String url) async {
    return await _prefs?.setString(StorageKeys.apiBaseUrl, url) ?? false;
  }

  /// Clear the stored API base URL
  static Future<bool> clearApiBaseUrl() async {
    return await _prefs?.remove(StorageKeys.apiBaseUrl) ?? false;
  }
}
