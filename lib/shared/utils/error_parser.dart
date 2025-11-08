import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

/// Common interface for API error responses
///
/// All generated error response types have these fields:
/// - success: false
/// - error: Error type/category
/// - message: Human-readable error message
abstract class ApiErrorResponse {
  bool? get success;
  String? get error;
  String? get message;
}

/// Extension to treat all error response types uniformly
extension ApiErrorExtension on dynamic {
  /// Check if this is a typed API error response
  bool get isApiErrorResponse {
    return this is ApiV1ScanPathPost400Response ||
        this is ApiV1ScanPathPost500Response ||
        this is ApiV1LibraryDelete400Response ||
        this is ApiV1LibraryDelete500Response ||
        this is ApiV1LibraryPut400Response ||
        this is ApiV1MoviesGet500Response ||
        this is ApiV1MoviesIdGet400Response ||
        this is ApiV1MoviesIdGet500Response ||
        this is ApiV1TvshowsGet500Response ||
        this is ApiV1TvshowsIdGet400Response ||
        this is ApiV1TvshowsIdGet500Response ||
        this is ApiV1SearchGet400Response ||
        this is ApiV1SearchGet500Response ||
        this is ApiV1SettingsGet500Response ||
        this is ApiV1SettingsPut500Response ||
        this is ApiV1SettingsFirstRunCompletePost500Response ||
        this is ApiV1StreamIdGet400Response ||
        this is ApiV1StreamIdGet500Response;
  }

  /// Extract message from typed error response
  String? get apiErrorMessage {
    // Try to get the message field via reflection/duck typing
    try {
      // All error responses have a 'message' getter
      if (this is ApiV1ScanPathPost400Response) {
        return (this as ApiV1ScanPathPost400Response).message;
      }
      if (this is ApiV1ScanPathPost500Response) {
        return (this as ApiV1ScanPathPost500Response).message;
      }
      if (this is ApiV1LibraryDelete400Response) {
        return (this as ApiV1LibraryDelete400Response).message;
      }
      if (this is ApiV1LibraryDelete500Response) {
        return (this as ApiV1LibraryDelete500Response).message;
      }
      if (this is ApiV1LibraryPut400Response) {
        return (this as ApiV1LibraryPut400Response).message;
      }
      // Add more as needed...
    } catch (_) {
      return null;
    }
    return null;
  }
}

/// Utility functions for parsing API errors using generated types
class ErrorParser {
  /// Parse API error to extract meaningful message
  ///
  /// Uses the generated OpenAPI types when available, falls back to
  /// dynamic parsing for untyped errors
  static String parseApiError(dynamic error, {String? fallbackMessage}) {
    // Handle DioException from the generated API client
    if (error is DioException && error.response?.data != null) {
      final data = error.response!.data;

      // Try to get message from typed error response
      if (data.isApiErrorResponse) {
        final message = data.apiErrorMessage;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      // Fallback: parse as map (for responses not yet typed above)
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }

        final errorType = data['error'] as String?;
        if (errorType != null && errorType.isNotEmpty) {
          return errorType;
        }
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
    }

    // Handle Exception objects
    if (error is Exception) {
      final errorStr = error.toString();

      if (errorStr.startsWith('Exception:')) {
        return errorStr
            .substring('Exception:'.length)
            .trim()
            .split('\n')
            .first
            .trim();
      }

      return errorStr.split('\n').first.trim();
    }

    // Handle plain error strings
    final errorStr = error.toString();
    if (errorStr.isNotEmpty && errorStr != 'null') {
      return errorStr.split('\n').first.trim();
    }

    return fallbackMessage ?? 'An error occurred';
  }

  /// Parse error for library operations
  static String parseLibraryError(dynamic error) {
    return parseApiError(error, fallbackMessage: 'Operation failed');
  }

  /// Parse error for scan operations
  static String parseScanError(dynamic error) {
    return parseApiError(error, fallbackMessage: 'Failed to start scan');
  }
}
