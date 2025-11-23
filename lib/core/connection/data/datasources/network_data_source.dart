// External packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

// Core
import 'package:dester/core/connection/domain/entities/connection_status.dart';
import 'package:dester/core/constants/app_version.dart';
import 'package:dester/core/utils/app_logger.dart';
import 'package:dester/core/utils/url_helper.dart';


/// Data source for network connectivity
abstract class NetworkDataSource {
  Future<bool> hasInternetConnectivity();
  Future<ConnectionStatus> checkApiConnection(String apiUrl);
}

/// Implementation of network data source
class NetworkDataSourceImpl implements NetworkDataSource {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> hasInternetConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      AppLogger.d('Connectivity check results: $connectivityResults');

      // Explicitly check for none first
      if (connectivityResults.contains(ConnectivityResult.none) &&
          connectivityResults.length == 1) {
        AppLogger.d('No internet connectivity detected');
        return false;
      }

      // Check for active connectivity types
      final hasConnectivity = connectivityResults.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn,
      );
      AppLogger.d('Internet connectivity: $hasConnectivity');
      return hasConnectivity;
    } catch (e, stackTrace) {
      AppLogger.e('Error checking internet connectivity', e, stackTrace);
      return false;
    }
  }

  @override
  Future<ConnectionStatus> checkApiConnection(String apiUrl) async {
    final stopwatch = Stopwatch()..start();
    try {
      // Normalize URL (replace localhost with 127.0.0.1 for better compatibility)
      final normalizedUrl = UrlHelper.normalizeUrl(apiUrl);

      // Use the /health endpoint for connection checking
      final healthUri = Uri.parse(normalizedUrl).resolve('/health');
      AppLogger.d('Checking API connection to: $healthUri');

      // Use Dio with reasonable timeout for health check
      // Health checks should be fast - fail quickly if API is not available
      final dio = Dio(
        BaseOptions(
          baseUrl: normalizedUrl,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(seconds: 5), // Fast timeout for health checks
          headers: {
            'X-Client-Version':
                AppVersion.version, // Include client version header
          },
        ),
      );

      final response = await dio.get('/health');

      stopwatch.stop();
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000;

      if (durationSeconds > 3) {
        AppLogger.w(
          'API connection check took ${durationSeconds.toStringAsFixed(2)}s (exceeds 3s threshold): $healthUri',
        );
      } else {
        AppLogger.d(
          'API connection check completed in ${durationSeconds.toStringAsFixed(2)}s',
        );
      }

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 400) {
        AppLogger.i('API connection successful: ${response.statusCode}');
        return ConnectionStatus.connected;
      } else {
        AppLogger.w(
          'API connection failed with status: ${response.statusCode}',
        );
        return ConnectionStatus.error;
      }
    } catch (e, stackTrace) {
      stopwatch.stop();
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000;
      if (durationSeconds > 3) {
        AppLogger.w(
          'API connection check failed after ${durationSeconds.toStringAsFixed(2)}s (exceeds 3s threshold): $apiUrl',
        );
      }
      AppLogger.e('Error checking API connection to $apiUrl', e, stackTrace);
      return ConnectionStatus.error;
    }
  }
}
