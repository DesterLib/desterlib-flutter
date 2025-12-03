/// API Health Status
enum ApiHealthStatus {
  /// Health check not started or idle
  idle,

  /// Currently checking health
  checking,

  /// API is healthy and responding
  healthy,

  /// API is unhealthy or not responding
  unhealthy,
}

/// Extension methods for ApiHealthStatus
extension ApiHealthStatusExtension on ApiHealthStatus {
  bool get isHealthy => this == ApiHealthStatus.healthy;
  bool get isUnhealthy => this == ApiHealthStatus.unhealthy;
  bool get isChecking => this == ApiHealthStatus.checking;
  bool get isIdle => this == ApiHealthStatus.idle;
}

/// API Health Result
class ApiHealth {
  final ApiHealthStatus status;
  final String? errorMessage;
  final int? statusCode;

  const ApiHealth({required this.status, this.errorMessage, this.statusCode});

  /// Create healthy status
  factory ApiHealth.healthy({int? statusCode}) {
    return ApiHealth(status: ApiHealthStatus.healthy, statusCode: statusCode);
  }

  /// Create unhealthy status
  factory ApiHealth.unhealthy({String? errorMessage, int? statusCode}) {
    return ApiHealth(
      status: ApiHealthStatus.unhealthy,
      errorMessage: errorMessage,
      statusCode: statusCode,
    );
  }

  /// Create checking status
  factory ApiHealth.checking() {
    return const ApiHealth(status: ApiHealthStatus.checking);
  }

  /// Create idle status
  factory ApiHealth.idle() {
    return const ApiHealth(status: ApiHealthStatus.idle);
  }

  bool get isHealthy => status == ApiHealthStatus.healthy;
  bool get isUnhealthy => status == ApiHealthStatus.unhealthy;
  bool get isChecking => status == ApiHealthStatus.checking;
  bool get isIdle => status == ApiHealthStatus.idle;
}
