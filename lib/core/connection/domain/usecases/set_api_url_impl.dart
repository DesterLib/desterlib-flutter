import '../../../utils/app_logger.dart';
import '../entities/connection_status.dart';
import '../repository/connection_repository.dart';
import 'set_api_url.dart';

/// Implementation of set API URL use case
class SetApiUrlImpl implements SetApiUrl {
  final ConnectionRepository repository;

  SetApiUrlImpl(this.repository);

  @override
  Future<ConnectionGuardState> call(String url) async {
    AppLogger.d('Setting API URL: $url');

    // Validate URL format
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (!uri.hasAuthority && uri.host.isEmpty)) {
        AppLogger.w('Invalid URL format: $url');
        return ConnectionGuardState(
          status: ConnectionStatus.error,
          errorMessage: 'Invalid URL format',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error parsing URL: $url', e, stackTrace);
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Invalid URL format: ${e.toString()}',
      );
    }

    // Save to repository
    final saved = await repository.setApiBaseUrl(url);
    if (!saved) {
      AppLogger.e('Failed to save API URL to preferences');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Failed to save API URL',
      );
    }
    AppLogger.i('API URL saved successfully');

    // Check connection with new URL
    final hasInternet = await repository.hasInternetConnectivity();
    if (!hasInternet) {
      AppLogger.w('No internet connection after setting API URL');
      return ConnectionGuardState(
        status: ConnectionStatus.disconnected,
        errorMessage: 'No internet connection',
        apiUrl: url,
      );
    }

    final status = await repository.checkApiConnection(url);
    String? errorMessage;
    if (status == ConnectionStatus.error) {
      errorMessage = 'Failed to connect to API';
      AppLogger.w('API connection failed: $errorMessage');
    } else {
      AppLogger.i('API URL set and connection verified: $status');
    }

    return ConnectionGuardState(
      status: status,
      errorMessage: errorMessage,
      apiUrl: url,
    );
  }
}
