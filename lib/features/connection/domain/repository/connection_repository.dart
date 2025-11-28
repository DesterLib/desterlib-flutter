// Core
import 'package:dester/features/connection/domain/entities/api_configuration.dart';
import 'package:dester/features/connection/domain/entities/connection_status.dart';


/// Repository interface for connection management (domain layer)
abstract class ConnectionRepository {
  /// Check if device has internet connectivity
  Future<bool> hasInternetConnectivity();

  /// Check API connection
  Future<ConnectionStatus> checkApiConnection(String apiUrl);

  /// Get all API configurations
  List<ApiConfiguration> getApiConfigurations();

  /// Save all API configurations
  Future<bool> saveApiConfigurations(List<ApiConfiguration> configurations);

  /// Get the active API configuration
  ApiConfiguration? getActiveApiConfiguration();
}
