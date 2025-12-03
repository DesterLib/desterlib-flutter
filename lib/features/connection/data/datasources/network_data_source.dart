// External packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

// Core
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/core/utils/app_logger.dart';
import 'package:dester/core/utils/url_helper.dart';
import 'package:dester/core/network/dester_api.dart';

/// Data source for network connectivity
abstract class NetworkDataSource {
  Future<bool> hasInternetConnectivity();
  Future<ConnectionStatus> checkApiConnection(String apiUrl);
}

/// Implementation of network data source using the new clean API
class NetworkDataSourceImpl implements NetworkDataSource {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> hasInternetConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();

      // Explicitly check for none first
      if (connectivityResults.contains(ConnectivityResult.none) &&
          connectivityResults.length == 1) {
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
      // Normalize URL
      final normalizedUrl = UrlHelper.normalizeUrl(apiUrl);

      // Create temporary isolated API client for this check
      final tempApi = DesterApi(
        baseUrl: normalizedUrl,
        timeout: const Duration(seconds: 10),
      );

      // Retry logic: try up to 2 times with 3s delay
      // WebSocket handles ongoing monitoring once connected
      int attempts = 0;
      const maxAttempts = 2;
      Exception? lastError;
      Map<String, dynamic>? response;

      while (attempts < maxAttempts) {
        try {
          response = await tempApi.health.check();
          if (attempts > 0) {
            AppLogger.i('API connection succeeded on attempt ${attempts + 1}');
          }
          break; // Success
        } on DioException catch (e) {
          attempts++;
          lastError = e;

          // Only retry on connection/timeout errors
          final isRetryable =
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError;

          if (isRetryable && attempts < maxAttempts) {
            final baseDelayMs = 3000;
            final delayMs = baseDelayMs * attempts;
            await Future.delayed(Duration(milliseconds: delayMs));
            continue;
          }

          break;
        } catch (e) {
          attempts++;
          lastError = Exception(e.toString());

          if (attempts < maxAttempts) {
            final delayMs = 3000 * attempts;
            await Future.delayed(Duration(milliseconds: delayMs));
            continue;
          }

          break;
        }
      }

      // Clean up temporary client
      tempApi.dispose();

      if (response == null) {
        final errorDetails = lastError != null
            ? lastError.toString()
            : 'Unknown error';
        throw Exception(
          'Failed to connect after $maxAttempts attempts. Last error: $errorDetails',
        );
      }

      stopwatch.stop();
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000;

      // Only log slow connections
      if (durationSeconds > 3) {
        AppLogger.w(
          'API connection check took ${durationSeconds.toStringAsFixed(2)}s',
        );
      }

      AppLogger.i('API connection successful');
      return ConnectionStatus.connected;
    } catch (e, stackTrace) {
      stopwatch.stop();
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000;
      if (durationSeconds > 3) {
        AppLogger.w(
          'API connection check failed after ${durationSeconds.toStringAsFixed(2)}s',
        );
      }
      AppLogger.e('Error checking API connection to $apiUrl', e, stackTrace);
      return ConnectionStatus.error;
    }
  }
}
