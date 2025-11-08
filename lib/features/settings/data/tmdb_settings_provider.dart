import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import '../../../app/providers.dart';
import '../../../core/providers/connection_provider.dart';

class TmdbSettingsNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final connectionStatus = ref.watch(connectionStatusProvider);

    if (connectionStatus == ConnectionStatus.connected) {
      return await _fetchApiKey();
    }

    return null;
  }

  Future<String?> _fetchApiKey() async {
    try {
      final client = ref.read(openapiClientProvider);
      final settingsApi = client.getSettingsApi();
      final response = await settingsApi.apiV1SettingsGet();

      final apiKey = response.data?.data?.tmdbApiKey;
      return apiKey != null && apiKey.isNotEmpty ? apiKey : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> setApiKey(String apiKey) async {
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

  Future<void> clearApiKey() async {
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

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _fetchApiKey());
  }
}

final tmdbSettingsProvider =
    AsyncNotifierProvider<TmdbSettingsNotifier, String?>(() {
      return TmdbSettingsNotifier();
    });

final isTmdbConfiguredProvider = Provider<bool>((ref) {
  final apiKeyAsync = ref.watch(tmdbSettingsProvider);
  return apiKeyAsync.maybeWhen(
    data: (apiKey) => apiKey != null && apiKey.isNotEmpty,
    orElse: () => false,
  );
});
