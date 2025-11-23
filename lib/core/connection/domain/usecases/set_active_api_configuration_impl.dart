// Core
import 'package:dester/core/connection/domain/entities/connection_status.dart';
import 'package:dester/core/connection/domain/repository/connection_repository.dart';
import 'package:dester/core/utils/app_logger.dart';
import 'package:dester/core/utils/url_helper.dart';

import 'set_active_api_configuration.dart';


/// Implementation of set active API configuration use case
class SetActiveApiConfigurationImpl implements SetActiveApiConfiguration {
  final ConnectionRepository repository;

  SetActiveApiConfigurationImpl(this.repository);

  @override
  Future<ConnectionGuardState> call(String configurationId) async {
    AppLogger.d('Setting active API configuration: $configurationId');

    // Get existing configurations
    final configurations = repository.getApiConfigurations();

    // Find the configuration to activate
    final configIndex = configurations.indexWhere(
      (config) => config.id == configurationId,
    );
    if (configIndex == -1) {
      AppLogger.w('API configuration not found: $configurationId');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'API configuration not found',
      );
    }

    // Update configurations: deactivate all, activate selected
    final updatedConfigurations = configurations.map((config) {
      return config.copyWith(isActive: config.id == configurationId);
    }).toList();

    // Save configurations
    final saved = await repository.saveApiConfigurations(updatedConfigurations);
    if (!saved) {
      AppLogger.e('Failed to save API configurations');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Failed to save API configurations',
      );
    }

    final activeConfig = updatedConfigurations[configIndex];
    AppLogger.i(
      'Active API configuration set: ${activeConfig.label} - ${activeConfig.url}',
    );

    // Check connection with new active API
    final hasInternet = await repository.hasInternetConnectivity();
    if (!hasInternet) {
      AppLogger.w('No internet connection');
      return ConnectionGuardState(
        status: ConnectionStatus.disconnected,
        errorMessage: 'No internet connection',
        apiUrl: activeConfig.url,
      );
    }

    final normalizedUrl = UrlHelper.normalizeUrl(activeConfig.url);
    final status = await repository.checkApiConnection(normalizedUrl);
    String? errorMessage;
    if (status == ConnectionStatus.error) {
      errorMessage = 'Failed to connect to API';
      AppLogger.w('API connection failed: $errorMessage');
    } else {
      AppLogger.i('Active API configuration connection verified: $status');
    }

    return ConnectionGuardState(
      status: status,
      errorMessage: errorMessage,
      apiUrl: activeConfig.url,
    );
  }
}
