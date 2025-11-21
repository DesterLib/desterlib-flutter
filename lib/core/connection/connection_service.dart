// Dependency injection setup for Connection service
import 'data/datasources/network_data_source.dart';
import 'data/datasources/preferences_data_source.dart';
import 'data/repository/connection_repository_impl.dart';
import 'domain/usecases/check_connection.dart';
import 'domain/usecases/check_connection_impl.dart';
import 'domain/usecases/clear_api_url.dart';
import 'domain/usecases/clear_api_url_impl.dart';
import 'domain/usecases/set_api_url.dart';
import 'domain/usecases/set_api_url_impl.dart';

class ConnectionService {
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

  /// Create set API URL use case
  static SetApiUrl createSetApiUrl() {
    final preferencesDataSource = PreferencesDataSourceImpl();
    final networkDataSource = NetworkDataSourceImpl();
    final repository = ConnectionRepositoryImpl(
      preferencesDataSource: preferencesDataSource,
      networkDataSource: networkDataSource,
    );
    return SetApiUrlImpl(repository);
  }

  /// Create clear API URL use case
  static ClearApiUrl createClearApiUrl() {
    final preferencesDataSource = PreferencesDataSourceImpl();
    final networkDataSource = NetworkDataSourceImpl();
    final repository = ConnectionRepositoryImpl(
      preferencesDataSource: preferencesDataSource,
      networkDataSource: networkDataSource,
    );
    return ClearApiUrlImpl(repository);
  }
}
