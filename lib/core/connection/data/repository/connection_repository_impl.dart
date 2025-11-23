// Core
import 'package:dester/core/connection/data/datasources/network_data_source.dart';
import 'package:dester/core/connection/data/datasources/preferences_data_source.dart';
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/connection/domain/entities/connection_status.dart';
import 'package:dester/core/connection/domain/repository/connection_repository.dart';


/// Repository implementation for connection management (data layer)
class ConnectionRepositoryImpl implements ConnectionRepository {
  final PreferencesDataSource preferencesDataSource;
  final NetworkDataSource networkDataSource;

  ConnectionRepositoryImpl({
    required this.preferencesDataSource,
    required this.networkDataSource,
  });

  @override
  Future<bool> hasInternetConnectivity() async {
    return networkDataSource.hasInternetConnectivity();
  }

  @override
  Future<ConnectionStatus> checkApiConnection(String apiUrl) async {
    return networkDataSource.checkApiConnection(apiUrl);
  }

  @override
  List<ApiConfiguration> getApiConfigurations() {
    return preferencesDataSource.getApiConfigurations();
  }

  @override
  Future<bool> saveApiConfigurations(
    List<ApiConfiguration> configurations,
  ) async {
    return preferencesDataSource.saveApiConfigurations(configurations);
  }

  @override
  ApiConfiguration? getActiveApiConfiguration() {
    return preferencesDataSource.getActiveApiConfiguration();
  }
}
