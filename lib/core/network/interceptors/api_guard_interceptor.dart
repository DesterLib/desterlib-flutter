// External packages
import 'package:dio/dio.dart';

// Core
import 'package:dester/core/storage/preferences_service.dart';
import 'package:dester/core/utils/app_logger.dart';

/// Interceptor to guard API requests - blocks requests if no API is configured
/// This prevents unnecessary API calls when the app hasn't been configured yet
class ApiGuardInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if API is configured before allowing the request
    final apiUrl = PreferencesService.getActiveApiUrl();
    if (apiUrl == null || apiUrl.isEmpty) {
      AppLogger.w(
        '🚫 API request blocked: No API configured - ${options.method} ${options.uri}',
      );
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'API URL not configured',
          type: DioExceptionType.unknown,
        ),
      );
      return;
    }

    super.onRequest(options, handler);
  }
}
