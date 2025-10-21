import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConfigService {
  static const String _baseUrlKey = 'server_base_url';

  final SharedPreferences _prefs;

  ConfigService(this._prefs);

  /// Get the stored base URL
  String? get baseUrl {
    final url = _prefs.getString(_baseUrlKey);
    return (url == null || url.isEmpty) ? null : url;
  }

  /// Check if base URL is configured
  bool get isConfigured => baseUrl != null;

  /// Save the base URL
  Future<bool> setBaseUrl(String url) async {
    // Clean up the URL
    final cleanUrl = url.trim();
    if (cleanUrl.isEmpty) {
      return await _prefs.remove(_baseUrlKey);
    }

    // Remove trailing slash if present
    final finalUrl = cleanUrl.endsWith('/')
        ? cleanUrl.substring(0, cleanUrl.length - 1)
        : cleanUrl;

    return await _prefs.setString(_baseUrlKey, finalUrl);
  }

  /// Clear the base URL
  Future<bool> clearBaseUrl() async {
    return await _prefs.remove(_baseUrlKey);
  }

  /// Test connection to the server (uses saved baseUrl)
  Future<bool> testConnection() async {
    if (baseUrl == null) return false;
    return await testUrl(baseUrl!);
  }

  /// Test connection to a specific URL without saving it
  Future<bool> testUrl(String url) async {
    if (url.isEmpty) return false;

    try {
      debugPrint('Testing connection to: $url/api/v1/settings');
      final uri = Uri.parse('$url/api/v1/settings');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      debugPrint('Response status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection test error: $e');
      return false;
    }
  }

  /// Get full API base URL with /api/v1
  String? get apiBaseUrl => baseUrl != null ? '$baseUrl/api/v1' : null;

  /// Create an instance
  static Future<ConfigService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ConfigService(prefs);
  }
}
