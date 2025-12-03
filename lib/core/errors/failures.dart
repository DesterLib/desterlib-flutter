/// Base class for all failures in the application
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

/// Failure indicating a server/API error
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {super.code, this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ServerError[$statusCode]: $message';
    }
    return 'ServerError: $message';
  }
}

/// Failure indicating a network connectivity issue
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});

  @override
  String toString() => 'NetworkError: $message';
}

/// Failure indicating a cache/local storage error
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});

  @override
  String toString() => 'CacheError: $message';
}

/// Failure indicating invalid input/validation error
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(super.message, {super.code, this.fieldErrors});

  @override
  String toString() => 'ValidationError: $message';
}

/// Failure indicating a permission/authorization error
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});

  @override
  String toString() => 'PermissionError: $message';
}

/// Generic failure for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});

  @override
  String toString() => 'UnknownError: $message';
}

/// Failure indicating authentication/authorization error
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});

  @override
  String toString() => 'AuthError: $message';
}

/// Failure indicating resource not found
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});

  @override
  String toString() => 'NotFoundError: $message';
}
