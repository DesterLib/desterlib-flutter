import 'package:dio/dio.dart';

/// Base API exception
sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';

  /// Create exception from DioException
  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        // Try to extract error message from response
        String message = 'Request failed';
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? message;
        }

        return switch (statusCode) {
          400 => BadRequestException(message, data: data),
          401 => UnauthorizedException(message, data: data),
          403 => ForbiddenException(message, data: data),
          404 => NotFoundException(message, data: data),
          500 => ServerException(message, data: data),
          _ => ApiException.unknown(
            message,
            statusCode: statusCode,
            data: data,
          ),
        };

      case DioExceptionType.cancel:
        return CancelledException('Request cancelled');

      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network settings.',
        );

      case DioExceptionType.badCertificate:
        return NetworkException('SSL certificate verification failed');

      case DioExceptionType.unknown:
        return UnknownException(
          error.message ?? 'An unknown error occurred',
          data: error.response?.data,
        );
    }
  }

  /// Create unknown exception
  factory ApiException.unknown(
    String message, {
    int? statusCode,
    dynamic data,
  }) {
    return UnknownException(message, statusCode: statusCode, data: data);
  }
}

/// Network connectivity exception
class NetworkException extends ApiException {
  const NetworkException(super.message, {super.statusCode, super.data});
}

/// Bad request (400)
class BadRequestException extends ApiException {
  const BadRequestException(
    super.message, {
    super.statusCode = 400,
    super.data,
  });
}

/// Unauthorized (401)
class UnauthorizedException extends ApiException {
  const UnauthorizedException(
    super.message, {
    super.statusCode = 401,
    super.data,
  });
}

/// Forbidden (403)
class ForbiddenException extends ApiException {
  const ForbiddenException(super.message, {super.statusCode = 403, super.data});
}

/// Not found (404)
class NotFoundException extends ApiException {
  const NotFoundException(super.message, {super.statusCode = 404, super.data});
}

/// Server error (500)
class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode = 500, super.data});
}

/// Request cancelled
class CancelledException extends ApiException {
  const CancelledException(super.message, {super.statusCode, super.data});
}

/// Unknown exception
class UnknownException extends ApiException {
  const UnknownException(super.message, {super.statusCode, super.data});
}
