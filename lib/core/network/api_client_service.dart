// External packages
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/storage/preferences_service.dart';
import 'package:dester/core/utils/url_helper.dart';

import 'interceptors/api_logging_interceptor.dart';
import 'interceptors/client_version_interceptor.dart';

/// Service for managing the OpenAPI client instance
class ApiClientService {
  static Openapi? _client;

  /// Get or create the OpenAPI client instance
  /// Uses the base URL from preferences if available, otherwise defaults to localhost
  /// Normalizes localhost to 127.0.0.1 for better cross-platform compatibility
  /// Adds client version header to all requests
  /// Uses longer timeout (5 minutes) to support scan operations
  static Openapi getClient() {
    if (_client != null) {
      return _client!;
    }

    final baseUrl =
        PreferencesService.getActiveApiUrl() ?? 'http://localhost:3001';
    final normalizedUrl = UrlHelper.normalizeUrl(baseUrl);

    // Create interceptors list with logging first, then client version, then default auth interceptors
    final interceptors = <Interceptor>[
      ApiLoggingInterceptor(),
      ClientVersionInterceptor(),
      OAuthInterceptor(),
      BasicAuthInterceptor(),
      BearerAuthInterceptor(),
      ApiKeyAuthInterceptor(),
    ];

    // Create Dio instance with reasonable timeout
    // Scan operations return 202 immediately, so we don't need a long timeout
    final dio = Dio(
      BaseOptions(
        baseUrl: normalizedUrl,
        connectTimeout: AppConstants.networkTimeout,
        receiveTimeout: const Duration(
          seconds: 10,
        ), // Short timeout since scan returns 202 immediately
      ),
    );

    dio.interceptors.addAll(interceptors);

    _client = Openapi(basePathOverride: normalizedUrl, dio: dio);
    return _client!;
  }

  /// Update the client with a new base URL
  /// This will recreate the client instance
  /// Normalizes localhost to 127.0.0.1 for better cross-platform compatibility
  static void updateBaseUrl(String baseUrl) {
    final normalizedUrl = UrlHelper.normalizeUrl(baseUrl);

    // Create interceptors list with logging first, then client version, then default auth interceptors
    final interceptors = <Interceptor>[
      ApiLoggingInterceptor(),
      ClientVersionInterceptor(),
      OAuthInterceptor(),
      BasicAuthInterceptor(),
      BearerAuthInterceptor(),
      ApiKeyAuthInterceptor(),
    ];

    // Create Dio instance with reasonable timeout
    // Scan operations return 202 immediately, so we don't need a long timeout
    final dio = Dio(
      BaseOptions(
        baseUrl: normalizedUrl,
        connectTimeout: AppConstants.networkTimeout,
        receiveTimeout: const Duration(
          seconds: 10,
        ), // Short timeout since scan returns 202 immediately
      ),
    );

    dio.interceptors.addAll(interceptors);

    _client = Openapi(basePathOverride: normalizedUrl, dio: dio);
  }

  /// Clear the client instance (useful for testing or reinitialization)
  static void clear() {
    _client = null;
  }
}
