import '../../domain/entities/connection_status.dart';
import '../../domain/repository/connection_repository.dart';
import '../datasources/network_data_source.dart';
import '../datasources/preferences_data_source.dart';

/// Repository implementation for connection management (data layer)
class ConnectionRepositoryImpl implements ConnectionRepository {
  final PreferencesDataSource preferencesDataSource;
  final NetworkDataSource networkDataSource;

  ConnectionRepositoryImpl({
    required this.preferencesDataSource,
    required this.networkDataSource,
  });

  @override
  Future<String?> getApiBaseUrl() async {
    return preferencesDataSource.getApiBaseUrl();
  }

  @override
  Future<bool> setApiBaseUrl(String url) async {
    return preferencesDataSource.setApiBaseUrl(url);
  }

  @override
  Future<bool> clearApiBaseUrl() async {
    return preferencesDataSource.clearApiBaseUrl();
  }

  @override
  Future<bool> hasInternetConnectivity() async {
    return networkDataSource.hasInternetConnectivity();
  }

  @override
  Future<ConnectionStatus> checkApiConnection(String apiUrl) async {
    return networkDataSource.checkApiConnection(apiUrl);
  }
}
