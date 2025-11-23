// External packages
import 'package:dio/dio.dart';

// Core
import 'package:dester/core/utils/app_logger.dart';


/// Interceptor to log all API requests and responses
/// Provides detailed logging for debugging API calls
class ApiLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d(
      '🌐 API Request: ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Query Parameters: ${options.queryParameters}\n'
      'Data: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d(
      '✅ API Response: ${response.requestOptions.method} ${response.requestOptions.uri}\n'
      'Status Code: ${response.statusCode}\n'
      'Headers: ${response.headers}\n'
      'Data: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '❌ API Error: ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      'Status Code: ${err.response?.statusCode}\n'
      'Error Type: ${err.type}\n'
      'Message: ${err.message}\n'
      'Response Data: ${err.response?.data}',
      err,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}
