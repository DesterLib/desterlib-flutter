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
      // Increased timeout to handle slow networks and API startup delays
      // Retry logic will handle transient failures
      final dio = Dio(
        BaseOptions(
          baseUrl: normalizedUrl,
          connectTimeout: const Duration(
            seconds: 10,
          ), // Increased from 5s to 10s
          receiveTimeout: const Duration(
            seconds: 10,
          ), // Increased from 5s to 10s
          headers: {
            'X-Client-Version':
                AppVersion.version, // Include client version header
          },
        ),
      );

      // Retry logic: try up to 4 times with exponential backoff
      // Router issues may need more attempts and longer delays
      // Connection errors that fail immediately (like "Connection refused") need longer delays
      // to allow router/network to recover
      Response? response;
      int attempts = 0;
      const maxAttempts = 4; // Increased from 3 to 4 for router issues
      DioException? lastError;

      while (attempts < maxAttempts) {
        try {
          response = await dio.get('/health');
          if (attempts > 0) {
            AppLogger.i('API connection succeeded on attempt ${attempts + 1}');
          }
          break; // Success, exit retry loop
        } on DioException catch (e) {
          attempts++;
          lastError = e;

          // Log the specific error type for debugging
          final errorType = e.type.toString().split('.').last;
          final errorMessage = e.message ?? 'Unknown error';
          AppLogger.d(
            'Connection attempt $attempts/$maxAttempts failed: $errorType - $errorMessage',
          );

          // Only retry on connection/timeout errors, not on HTTP errors
          final isRetryable =
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError;

          if (isRetryable && attempts < maxAttempts) {
            // For connection errors that fail immediately (like "Connection refused"),
            // use longer delays to allow router/network to recover
            // Router issues often need more time: 3s, 6s, 9s
            final baseDelayMs = 3000; // Start with 3 seconds for router issues
            final delayMs = baseDelayMs * attempts;

            AppLogger.d(
              'Retrying connection in ${delayMs}ms (attempt ${attempts + 1}/$maxAttempts)...',
            );
            await Future.delayed(Duration(milliseconds: delayMs));
            continue;
          }

          // If not retryable or exhausted retries, break to handle error
          break;
        }
      }

      if (response == null) {
        // Provide more detailed error message
        final errorDetails = lastError != null
            ? '${lastError.type.toString().split('.').last}: ${lastError.message ?? "Unknown error"}'
            : 'Unknown error';
        throw Exception(
          'Failed to connect after $maxAttempts attempts. Last error: $errorDetails',
        );
      }

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

      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 400) {
        AppLogger.i('API connection successful: ${response.statusCode}');
        return ConnectionStatus.connected;
      } else {
        AppLogger.w('API connection failed with status: $statusCode');
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
