import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';
import '../core/config/api_config.dart';

/// Notifier for managing the API base URL
class BaseUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return ApiConfig.baseUrl;
  }

  /// Update the base URL
  void updateUrl(String newUrl) {
    state = newUrl;
  }
}

/// Provider for the current API base URL.
/// This is used to make the OpenAPI client reactive to URL changes.
final baseUrlProvider = NotifierProvider<BaseUrlNotifier, String>(() {
  return BaseUrlNotifier();
});

/// Global provider for the generated OpenAPI client.
/// This is a singleton that can be accessed throughout the app via ref.watch() or ref.read()
///
/// Usage in features:
/// ```dart
/// // In a feature controller/provider:
/// final moviesProvider = FutureProvider<List<Movie>>((ref) async {
///   final client = ref.watch(openapiClientProvider);
///   final moviesApi = client.getMoviesApi();
///   final response = await moviesApi.apiV1MoviesGet();
///   return response.data ?? [];
/// });
/// ```
final openapiClientProvider = Provider<Openapi>((ref) {
  // Watch the base URL so the client gets recreated when it changes
  final baseUrl = ref.watch(baseUrlProvider);

  // Create Dio with longer timeouts for operations like scanning
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: ApiConfig.timeout, // 30 seconds
      sendTimeout: ApiConfig.timeout,
    ),
  );

  return Openapi(basePathOverride: baseUrl, dio: dio);
});
