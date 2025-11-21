import '../../../../../core/utils/app_logger.dart';
import '../entities/connection_status.dart';
import '../repository/connection_repository.dart';
import 'check_connection.dart';

/// Implementation of check connection use case
class CheckConnectionImpl implements CheckConnection {
  final ConnectionRepository repository;

  CheckConnectionImpl(this.repository);

  @override
  Future<ConnectionGuardState> call() async {
    AppLogger.d('Checking connection...');

    // Check internet connectivity first
    final hasInternet = await repository.hasInternetConnectivity();

    if (!hasInternet) {
      AppLogger.w('No internet connection detected');
      return ConnectionGuardState(
        status: ConnectionStatus.disconnected,
        errorMessage: 'No internet connection',
      );
    }

    // Get API URL
    final apiUrl = await repository.getApiBaseUrl();

    if (apiUrl == null || apiUrl.isEmpty) {
      AppLogger.w('API URL not configured');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'API URL not configured',
        apiUrl: apiUrl,
      );
    }

    // Check API connection
    final status = await repository.checkApiConnection(apiUrl);

    String? errorMessage;
    if (status == ConnectionStatus.error) {
      errorMessage = 'Failed to connect to API';
      AppLogger.w('API connection failed: $errorMessage');
    } else {
      AppLogger.i('Connection check completed: $status');
    }

    return ConnectionGuardState(
      status: status,
      errorMessage: errorMessage,
      apiUrl: apiUrl,
    );
  }
}
