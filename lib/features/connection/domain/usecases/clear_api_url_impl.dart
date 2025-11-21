import '../entities/connection_status.dart';
import '../repository/connection_repository.dart';
import 'clear_api_url.dart';

/// Implementation of clear API URL use case
class ClearApiUrlImpl implements ClearApiUrl {
  final ConnectionRepository repository;

  ClearApiUrlImpl(this.repository);

  @override
  Future<ConnectionGuardState> call() async {
    await repository.clearApiBaseUrl();
    return ConnectionGuardState(
      status: ConnectionStatus.error,
      errorMessage: 'API URL not configured',
      apiUrl: null,
    );
  }
}
