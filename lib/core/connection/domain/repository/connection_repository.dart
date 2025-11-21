import '../entities/connection_status.dart';

/// Repository interface for connection management (domain layer)
abstract class ConnectionRepository {
  /// Get the stored API base URL
  Future<String?> getApiBaseUrl();

  /// Set the API base URL
  Future<bool> setApiBaseUrl(String url);

  /// Clear the stored API base URL
  Future<bool> clearApiBaseUrl();

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnectivity();

  /// Check API connection
  Future<ConnectionStatus> checkApiConnection(String apiUrl);
}
