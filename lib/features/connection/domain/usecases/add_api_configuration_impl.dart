// Core
import 'package:dester/features/connection/domain/entities/api_configuration.dart';
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/features/connection/domain/repository/connection_repository.dart';
import 'package:dester/core/utils/app_logger.dart';
import 'package:dester/core/utils/url_helper.dart';

import 'add_api_configuration.dart';

/// Implementation of add API configuration use case
class AddApiConfigurationImpl implements AddApiConfiguration {
  final ConnectionRepository repository;

  AddApiConfigurationImpl(this.repository);

  @override
  Future<ConnectionGuardState> call(
    String url,
    String label, {
    bool setAsActive = false,
  }) async {
    AppLogger.d('Adding API configuration: $label - $url');

    // Validate URL format
    if (url.trim().isEmpty) {
      AppLogger.w('URL cannot be empty');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'URL cannot be empty',
      );
    }

    try {
      final uri = Uri.parse(url.trim());
      // Check if URL has a valid scheme (http, https, etc.)
      if (!uri.hasScheme) {
        AppLogger.w('Invalid URL format: missing scheme - $url');
        return ConnectionGuardState(
          status: ConnectionStatus.error,
          errorMessage:
              'Invalid URL format: missing scheme (http:// or https://)',
        );
      }
      // Check if URL has a valid host or authority
      if (uri.host.isEmpty && !uri.hasAuthority) {
        AppLogger.w('Invalid URL format: missing host - $url');
        return ConnectionGuardState(
          status: ConnectionStatus.error,
          errorMessage: 'Invalid URL format: missing host',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error parsing URL: $url', e, stackTrace);
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Invalid URL format: ${e.toString()}',
      );
    }

    // Validate label
    if (label.trim().isEmpty) {
      AppLogger.w('Label cannot be empty');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Label cannot be empty',
      );
    }

    // Get existing configurations
    final configurations = repository.getApiConfigurations();

    // Check if URL already exists
    if (configurations.any((config) => config.url == url.trim())) {
      AppLogger.w('API URL already exists: $url');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'This API URL already exists',
      );
    }

    // Create new configuration
    final newConfig = ApiConfiguration(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url.trim(),
      label: label.trim(),
      isActive: setAsActive,
    );

    // If setting as active, deactivate all others
    final updatedConfigurations = configurations.map((config) {
      if (setAsActive) {
        return config.copyWith(isActive: false);
      }
      return config;
    }).toList();

    updatedConfigurations.add(newConfig);

    // Save configurations
    final saved = await repository.saveApiConfigurations(updatedConfigurations);
    if (!saved) {
      AppLogger.e('Failed to save API configuration');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'Failed to save API configuration',
      );
    }

    AppLogger.i('API configuration added successfully');

    // If set as active, check connection
    if (setAsActive) {
      final hasInternet = await repository.hasInternetConnectivity();
      if (!hasInternet) {
        AppLogger.w('No internet connection');
        return ConnectionGuardState(
          status: ConnectionStatus.disconnected,
          errorMessage: 'No internet connection',
          apiUrl: newConfig.url,
        );
      }

      final normalizedUrl = UrlHelper.normalizeUrl(newConfig.url);
      final status = await repository.checkApiConnection(normalizedUrl);
      String? errorMessage;
      if (status == ConnectionStatus.error) {
        errorMessage = 'Failed to connect to API';
        AppLogger.w('API connection failed: $errorMessage');
      } else {
        AppLogger.i('API configuration added and connection verified: $status');
      }

      return ConnectionGuardState(
        status: status,
        errorMessage: errorMessage,
        apiUrl: newConfig.url,
      );
    }

    // Return current active configuration state
    final activeConfig = repository.getActiveApiConfiguration();
    return ConnectionGuardState(
      status: ConnectionStatus.connected,
      apiUrl: activeConfig?.url,
    );
  }
}
