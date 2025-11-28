// Core
import 'package:dester/features/connection/domain/entities/api_configuration.dart';
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/features/connection/domain/repository/connection_repository.dart';
import 'package:dester/core/utils/app_logger.dart';

import 'delete_api_configuration.dart';


/// Implementation of delete API configuration use case
class DeleteApiConfigurationImpl implements DeleteApiConfiguration {
  final ConnectionRepository repository;

  DeleteApiConfigurationImpl(this.repository);

  @override
  Future<ConnectionGuardState> call(String configurationId) async {
    AppLogger.d('Deleting API configuration: $configurationId');

    // Get existing configurations
    final configurations = repository.getApiConfigurations();

    // Check if configuration exists
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

    final configToDelete = configurations[configIndex];
    final wasActive = configToDelete.isActive;

    // Remove the configuration
    final updatedConfigurations = <ApiConfiguration>[...configurations]
      ..removeAt(configIndex);

    // If deleted config was active and there are other configs, activate the first one
    if (wasActive && updatedConfigurations.isNotEmpty) {
      updatedConfigurations[0] = updatedConfigurations[0].copyWith(
        isActive: true,
      );
    }

    // Save configurations
    final saved = await repository.saveApiConfigurations(updatedConfigurations);
    if (!saved) {
      AppLogger.e('Failed to save API configurations');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Failed to save API configurations',
      );
    }

    AppLogger.i('API configuration deleted successfully');

    // Return current active configuration state
    final activeConfig = repository.getActiveApiConfiguration();
    return ConnectionGuardState(
      status: activeConfig != null
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected,
      apiUrl: activeConfig?.url,
    );
  }
}
