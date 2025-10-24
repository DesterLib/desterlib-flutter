import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing TMDB API key settings
class TmdbSettingsNotifier extends Notifier<String?> {
  @override
  String? build() {
    _loadApiKey();
    return null;
  }

  static const String _apiKeyKey = 'tmdb_api_key';

  /// Load the API key from shared preferences
  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(_apiKeyKey);
    if (apiKey != null && apiKey.isNotEmpty) {
      state = apiKey;
    }
  }

  /// Save the API key to shared preferences
  Future<void> setApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
    state = apiKey;
  }

  /// Clear the API key
  Future<void> clearApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyKey);
    state = null;
  }

  /// Check if TMDB API key is configured
  bool get isApiKeyConfigured => state != null && state!.isNotEmpty;

  /// Get the current API key
  String? get apiKey => state;
}

/// Provider for TMDB settings
final tmdbSettingsProvider = NotifierProvider<TmdbSettingsNotifier, String?>(() {
  return TmdbSettingsNotifier();
});

/// Provider to check if TMDB API key is configured
final isTmdbConfiguredProvider = Provider<bool>((ref) {
  final apiKey = ref.watch(tmdbSettingsProvider);
  return apiKey != null && apiKey.isNotEmpty;
});
