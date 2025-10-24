import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String defaultBaseUrl = 'http://localhost:3000';
  static const String apiVersion = 'v1';
  static const Duration timeout = Duration(seconds: 30);
  static const String _baseUrlKey = 'api_base_url';

  static String _cachedBaseUrl = defaultBaseUrl;

  // Get the base URL from cache or default
  static String get baseUrl => _cachedBaseUrl;

  static String get apiBaseUrl => '$baseUrl/api/$apiVersion';

  // Health check endpoint
  static String get healthUrl => '$baseUrl/health';

  // Settings endpoints
  static String get settingsUrl => '$apiBaseUrl/settings';

  // Load base URL from shared preferences
  static Future<void> loadBaseUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString(_baseUrlKey);
      if (savedUrl != null && savedUrl.isNotEmpty) {
        _cachedBaseUrl = savedUrl;
      }
    } catch (e) {
      // If loading fails, use default
      _cachedBaseUrl = defaultBaseUrl;
    }
  }

  // Save base URL to shared preferences
  static Future<void> saveBaseUrl(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_baseUrlKey, url);
      _cachedBaseUrl = url;
    } catch (e) {
      // If saving fails, keep current value
    }
  }

  // Reset to default URL
  static Future<void> resetToDefault() async {
    await saveBaseUrl(defaultBaseUrl);
  }
}
