import '../entities/connection_status.dart';
import '../repository/connection_repository.dart';
import 'set_api_url.dart';

/// Implementation of set API URL use case
class SetApiUrlImpl implements SetApiUrl {
  final ConnectionRepository repository;

  SetApiUrlImpl(this.repository);

  @override
  Future<ConnectionGuardState> call(String url) async {
    // Validate URL format
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (!uri.hasAuthority && uri.host.isEmpty)) {
        return ConnectionGuardState(
          status: ConnectionStatus.error,
          errorMessage: 'Invalid URL format',
        );
      }
    } catch (e) {
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Invalid URL format: ${e.toString()}',
      );
    }

    // Save to repository
    final saved = await repository.setApiBaseUrl(url);
    if (!saved) {
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Failed to save API URL',
      );
    }

    // Check connection with new URL
    final hasInternet = await repository.hasInternetConnectivity();
    if (!hasInternet) {
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
    }

    return ConnectionGuardState(
      status: status,
      errorMessage: errorMessage,
      apiUrl: url,
    );
  }
}
