import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String defaultBaseUrl = 'http://localhost:3001';

  /// API route version (e.g., 'v1' for /api/v1/...)
  /// This is the API endpoint version, not the semantic version
  static const String apiRouteVersion = 'v1';

  /// Client semantic version (e.g., '0.1.0')
  /// This should match the version in pubspec.yaml and is synced from root package.json
  /// The actual API semantic version will be fetched from the /health endpoint
  static const String clientVersion = '0.2.0'; // Synced from root package.json // Synced from root package.json // Synced from root package.json

  static const Duration timeout = Duration(seconds: 30);
  static const String _baseUrlKey = 'api_base_url';

  static String _cachedBaseUrl = defaultBaseUrl;

  // Get the base URL from cache or default
  static String get baseUrl => _cachedBaseUrl;

  static String get apiBaseUrl => '$baseUrl/api/$apiRouteVersion';

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
