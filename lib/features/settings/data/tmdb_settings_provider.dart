import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_api_service.dart';
import '../../../core/providers/connection_provider.dart';

/// Provider for managing TMDB API key settings
class TmdbSettingsNotifier extends Notifier<String?> {
  @override
  String? build() {
    _loadSettings();
    return null;
  }

  static const String _apiKeyKey = 'tmdb_api_key';

  /// Load settings from API or fallback to local storage
  Future<void> _loadSettings() async {
    try {
      // First try to get from API if connected
      final connectionStatus = ref.read(connectionStatusProvider);
      if (connectionStatus == ConnectionStatus.connected) {
        final apiService = ref.read(settingsApiServiceProvider);
        final settings = await apiService.getSettings();
        final apiKey = settings['tmdbApiKey'] as String?;
        if (apiKey != null && apiKey.isNotEmpty) {
          state = apiKey;
          // Cache locally for offline access
          await _cacheApiKey(apiKey);
          return;
        }
      }

      // Fallback to local storage
      await _loadFromCache();
    } catch (e) {
      // If API fails, try local storage
      await _loadFromCache();
    }
  }

  /// Load from local cache
  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(_apiKeyKey);
    if (apiKey != null && apiKey.isNotEmpty) {
      state = apiKey;
    }
  }

  /// Cache API key locally
  Future<void> _cacheApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  /// Save the API key to both API and local storage
  Future<void> setApiKey(String apiKey) async {
    try {
      // Try to save to API first if connected
      final connectionStatus = ref.read(connectionStatusProvider);
      if (connectionStatus == ConnectionStatus.connected) {
        final apiService = ref.read(settingsApiServiceProvider);
        await apiService.updateTmdbApiKey(apiKey);
      }

      // Always cache locally
      await _cacheApiKey(apiKey);
      state = apiKey;
    } catch (e) {
      // If API fails, still save locally
      await _cacheApiKey(apiKey);
      state = apiKey;
      rethrow; // Re-throw so UI can handle the error
    }
  }

  /// Clear the API key from both API and local storage
  Future<void> clearApiKey() async {
    try {
      // Try to clear from API first if connected
      final connectionStatus = ref.read(connectionStatusProvider);
      if (connectionStatus == ConnectionStatus.connected) {
        final apiService = ref.read(settingsApiServiceProvider);
        await apiService.updateTmdbApiKey('');
      }

      // Clear from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_apiKeyKey);
      state = null;
    } catch (e) {
      // If API fails, still clear locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_apiKeyKey);
      state = null;
      rethrow; // Re-throw so UI can handle the error
    }
  }

  /// Check if TMDB API key is configured
  bool get isApiKeyConfigured => state != null && state!.isNotEmpty;

  /// Get the current API key
  String? get apiKey => state;

  /// Refresh settings from API
  Future<void> refreshFromApi() async {
    await _loadSettings();
  }
}

/// Provider for TMDB settings
final tmdbSettingsProvider = NotifierProvider<TmdbSettingsNotifier, String?>(
  () {
    return TmdbSettingsNotifier();
  },
);

/// Provider to check if TMDB API key is configured
final isTmdbConfiguredProvider = Provider<bool>((ref) {
  final apiKey = ref.watch(tmdbSettingsProvider);
  return apiKey != null && apiKey.isNotEmpty;
});
