// Dependency injection setup for Connection feature
import 'data/datasources/network_data_source.dart';
import 'data/datasources/preferences_data_source.dart';
import 'data/repository/connection_repository_impl.dart';
import 'domain/usecases/add_api_configuration.dart';
import 'domain/usecases/add_api_configuration_impl.dart';
import 'domain/usecases/check_connection.dart';
import 'domain/usecases/check_connection_impl.dart';
import 'domain/usecases/delete_api_configuration.dart';
import 'domain/usecases/delete_api_configuration_impl.dart';
import 'domain/usecases/get_api_configurations.dart';
import 'domain/usecases/get_api_configurations_impl.dart';
import 'domain/usecases/set_active_api_configuration.dart';
import 'domain/usecases/set_active_api_configuration_impl.dart';

class ConnectionFeature {
  /// Create check connection use case
  static CheckConnection createCheckConnection() {
    final preferencesDataSource = PreferencesDataSourceImpl();
    final networkDataSource = NetworkDataSourceImpl();
    final repository = ConnectionRepositoryImpl(
      preferencesDataSource: preferencesDataSource,
      networkDataSource: networkDataSource,
    );
    return CheckConnectionImpl(repository);
  }

  /// Create add API configuration use case
  static AddApiConfiguration createAddApiConfiguration() {
    final preferencesDataSource = PreferencesDataSourceImpl();
    final networkDataSource = NetworkDataSourceImpl();
    final repository = ConnectionRepositoryImpl(
      preferencesDataSource: preferencesDataSource,
      networkDataSource: networkDataSource,
    );
    return AddApiConfigurationImpl(repository);
  }

  /// Create set active API configuration use case
  static SetActiveApiConfiguration createSetActiveApiConfiguration() {
    final preferencesDataSource = PreferencesDataSourceImpl();
    final networkDataSource = NetworkDataSourceImpl();
    final repository = ConnectionRepositoryImpl(
      preferencesDataSource: preferencesDataSource,
      networkDataSource: networkDataSource,
    );
    return SetActiveApiConfigurationImpl(repository);
  }

  /// Create delete API configuration use case
  static DeleteApiConfiguration createDeleteApiConfiguration() {
    final preferencesDataSource = PreferencesDataSourceImpl();
    final networkDataSource = NetworkDataSourceImpl();
    final repository = ConnectionRepositoryImpl(
      preferencesDataSource: preferencesDataSource,
      networkDataSource: networkDataSource,
    );
    return DeleteApiConfigurationImpl(repository);
  }

  /// Create get API configurations use case
  static GetApiConfigurations createGetApiConfigurations() {
    final preferencesDataSource = PreferencesDataSourceImpl();
    final networkDataSource = NetworkDataSourceImpl();
    final repository = ConnectionRepositoryImpl(
      preferencesDataSource: preferencesDataSource,
      networkDataSource: networkDataSource,
    );
    return GetApiConfigurationsImpl(repository);
  }
}
