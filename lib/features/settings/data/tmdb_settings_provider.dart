import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import '../../../app/providers.dart';
import '../../../core/providers/connection_provider.dart';

/// Provider for managing TMDB API key settings
class TmdbSettingsNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    // Listen to connection status changes
    final connectionStatus = ref.watch(connectionStatusProvider);

    // Load settings when connected
    if (connectionStatus == ConnectionStatus.connected) {
      return await _loadSettings();
    }

    return null;
  }

  /// Load settings from API
  Future<String?> _loadSettings() async {
    try {
      final connectionStatus = ref.read(connectionStatusProvider);
      if (connectionStatus == ConnectionStatus.connected) {
        final client = ref.read(openapiClientProvider);
        final settingsApi = client.getSettingsApi();
        final response = await settingsApi.apiV1SettingsGet();

        final data = response.data?.data;
        final apiKey = data?.tmdbApiKey;
        return apiKey != null && apiKey.isNotEmpty ? apiKey : null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save the API key to the server
  Future<void> setApiKey(String apiKey) async {
    final connectionStatus = ref.read(connectionStatusProvider);
    if (connectionStatus != ConnectionStatus.connected) {
      throw Exception('Not connected to API server');
    }

    state = const AsyncValue.loading();

    try {
      final client = ref.read(openapiClientProvider);
      final settingsApi = client.getSettingsApi();

      final request = UpdateSettingsRequestBuilder()..tmdbApiKey = apiKey;

      await settingsApi.apiV1SettingsPut(
        updateSettingsRequest: request.build(),
      );

      state = AsyncValue.data(apiKey);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Clear the API key from the server
  Future<void> clearApiKey() async {
    final connectionStatus = ref.read(connectionStatusProvider);
    if (connectionStatus != ConnectionStatus.connected) {
      throw Exception('Not connected to API server');
    }

    state = const AsyncValue.loading();

    try {
      final client = ref.read(openapiClientProvider);
      final settingsApi = client.getSettingsApi();

      final request = UpdateSettingsRequestBuilder()..tmdbApiKey = '';

      await settingsApi.apiV1SettingsPut(
        updateSettingsRequest: request.build(),
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Refresh settings from API
  Future<void> refreshFromApi() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadSettings());
  }
}

/// Provider for TMDB settings
final tmdbSettingsProvider =
    AsyncNotifierProvider<TmdbSettingsNotifier, String?>(() {
      return TmdbSettingsNotifier();
    });

/// Provider to check if TMDB API key is configured
final isTmdbConfiguredProvider = Provider<bool>((ref) {
  final apiKeyAsync = ref.watch(tmdbSettingsProvider);
  return apiKeyAsync.maybeWhen(
    data: (apiKey) => apiKey != null && apiKey.isNotEmpty,
    orElse: () => false,
  );
});
