// Core
import 'package:dester/core/network/dester_api.dart';
import 'package:dester/core/utils/app_logger.dart';
import 'package:dester/core/utils/url_helper.dart';

// Features
import 'package:dester/features/connection/domain/entities/api_health.dart';
import 'package:dester/features/connection/domain/usecases/check_api_health.dart';

/// Implementation of CheckApiHealth use case
/// Uses a temporary isolated API client to avoid race conditions
class CheckApiHealthImpl implements CheckApiHealth {
  @override
  Future<ApiHealth> call(String url) async {
    // Validate URL is not empty
    if (url.isEmpty) {
      return ApiHealth.idle();
    }

    // Validate URL format
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (uri.host.isEmpty && !uri.hasAuthority)) {
        return ApiHealth.unhealthy(errorMessage: 'Invalid URL format');
      }
    } catch (e) {
      return ApiHealth.unhealthy(errorMessage: 'Invalid URL: ${e.toString()}');
    }

    // Perform health check with temporary isolated client
    try {
      final normalizedUrl = UrlHelper.normalizeUrl(url);

      // Create temporary API client - isolated from global state
      final tempApi = DesterApi(
        baseUrl: normalizedUrl,
        timeout: const Duration(seconds: 10),
      );

      try {
        await tempApi.health.check();
        return ApiHealth.healthy(statusCode: 200);
      } finally {
        // Always clean up the temporary client
        tempApi.dispose();
      }
    } catch (e, stackTrace) {
      AppLogger.e('API health check error: $url', e, stackTrace);
      return ApiHealth.unhealthy(errorMessage: e.toString());
    }
  }
}
