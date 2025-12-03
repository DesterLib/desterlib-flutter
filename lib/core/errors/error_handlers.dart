import 'package:dio/dio.dart';

import 'failures.dart';
import '../network/api_exception.dart';

/// Convert DioException to appropriate Failure
Failure dioExceptionToFailure(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return NetworkFailure(
        'Connection timeout. Please check your internet connection.',
        code: 'CONNECTION_TIMEOUT',
      );

    case DioExceptionType.badResponse:
      final statusCode = exception.response?.statusCode;
      final message =
          exception.response?.data?['message']?.toString() ??
          exception.message ??
          'Server error occurred';

      // Handle specific status codes
      if (statusCode == 401) {
        return PermissionFailure(
          'Unauthorized. Please check your credentials.',
          code: 'UNAUTHORIZED',
        );
      } else if (statusCode == 403) {
        return PermissionFailure('Access forbidden.', code: 'FORBIDDEN');
      } else if (statusCode == 404) {
        return ServerFailure(
          'Resource not found.',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );
      } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return ValidationFailure(message, code: 'CLIENT_ERROR');
      } else {
        return ServerFailure(
          message,
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );
      }

    case DioExceptionType.cancel:
      return NetworkFailure(
        'Request was cancelled.',
        code: 'REQUEST_CANCELLED',
      );

    case DioExceptionType.connectionError:
      return NetworkFailure(
        'No internet connection. Please check your network settings.',
        code: 'NO_CONNECTION',
      );

    case DioExceptionType.badCertificate:
      return NetworkFailure(
        'SSL certificate error. Please check your connection.',
        code: 'SSL_ERROR',
      );

    case DioExceptionType.unknown:
      // Check if it's a network error
      if (exception.error != null) {
        final error = exception.error.toString().toLowerCase();
        if (error.contains('network') ||
            error.contains('socket') ||
            error.contains('internet')) {
          return NetworkFailure(
            'Network error. Please check your internet connection.',
            code: 'NETWORK_ERROR',
          );
        }
      }

      return UnknownFailure(
        exception.message ?? 'An unknown error occurred',
        code: 'UNKNOWN_ERROR',
      );
  }
}

/// Convert any exception to Failure
Failure exceptionToFailure(Object exception, [String? context]) {
  if (exception is Failure) {
    return exception;
  }

  if (exception is DioException) {
    return dioExceptionToFailure(exception);
  }

  final message = exception.toString();
  final contextMessage = context != null ? '$context: $message' : message;

  return UnknownFailure(contextMessage);
}

/// Extension to convert ApiException to Failure
/// This eliminates duplication across data sources
extension ApiExceptionToFailure on ApiException {
  /// Convert this ApiException to appropriate Failure type
  Failure toFailure() {
    return switch (this) {
      NetworkException() => NetworkFailure(message),
      BadRequestException() => ValidationFailure(message),
      UnauthorizedException() => AuthFailure(message),
      ForbiddenException() => AuthFailure(message),
      NotFoundException() => NotFoundFailure(message),
      ServerException() => ServerFailure(message),
      CancelledException() => NetworkFailure(message),
      UnknownException() => ServerFailure(message),
    };
  }
}
