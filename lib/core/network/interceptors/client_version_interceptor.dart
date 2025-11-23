// External packages
import 'package:dio/dio.dart';

// Core
import 'package:dester/core/constants/app_version.dart';


/// Interceptor to add client version header to all API requests
class ClientVersionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Client-Version'] = AppVersion.version;
    super.onRequest(options, handler);
  }
}
