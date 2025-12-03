// Dependency injection setup for Connection feature
import 'data/datasources/network_data_source.dart';
import 'data/datasources/preferences_data_source.dart';
import 'data/repository/connection_repository_impl.dart';
import 'domain/usecases/add_api_configuration.dart';
import 'domain/usecases/add_api_configuration_impl.dart';
import 'domain/usecases/check_api_health.dart';
import 'domain/usecases/check_api_health_impl.dart';
import 'domain/usecases/check_connection.dart';
import 'domain/usecases/check_connection_impl.dart';
import 'domain/usecases/delete_api_configuration.dart';
import 'domain/usecases/delete_api_configuration_impl.dart';
import 'domain/usecases/get_api_configurations.dart';
import 'domain/usecases/get_api_configurations_impl.dart';
import 'domain/usecases/set_active_api_configuration.dart';
import 'domain/usecases/set_active_api_configuration_impl.dart';

class ConnectionFeature {
  // Singleton instances
  static PreferencesDataSourceImpl? _preferencesDataSource;
  static NetworkDataSourceImpl? _networkDataSource;
  static ConnectionRepositoryImpl? _repository;
  static CheckApiHealth? _checkApiHealth;

  // Private helper to get or create data sources
  static PreferencesDataSourceImpl _getPreferencesDataSource() {
    _preferencesDataSource ??= PreferencesDataSourceImpl();
    return _preferencesDataSource!;
  }

  static NetworkDataSourceImpl _getNetworkDataSource() {
    _networkDataSource ??= NetworkDataSourceImpl();
    return _networkDataSource!;
  }

  static ConnectionRepositoryImpl _getRepository() {
    _repository ??= ConnectionRepositoryImpl(
      preferencesDataSource: _getPreferencesDataSource(),
      networkDataSource: _getNetworkDataSource(),
    );
    return _repository!;
  }

  /// Create check connection use case
  static CheckConnection createCheckConnection() {
    return CheckConnectionImpl(_getRepository());
  }

  /// Create add API configuration use case
  static AddApiConfiguration createAddApiConfiguration() {
    return AddApiConfigurationImpl(_getRepository());
  }

  /// Create set active API configuration use case
  static SetActiveApiConfiguration createSetActiveApiConfiguration() {
    return SetActiveApiConfigurationImpl(_getRepository());
  }

  /// Create delete API configuration use case
  static DeleteApiConfiguration createDeleteApiConfiguration() {
    return DeleteApiConfigurationImpl(_getRepository());
  }

  /// Create get API configurations use case
  static GetApiConfigurations createGetApiConfigurations() {
    return GetApiConfigurationsImpl(_getRepository());
  }

  /// Create check API health use case (singleton)
  static CheckApiHealth createCheckApiHealth() {
    _checkApiHealth ??= CheckApiHealthImpl();
    return _checkApiHealth!;
  }
}
