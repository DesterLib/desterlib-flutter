// Core
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/features/connection/domain/repository/connection_repository.dart';
import 'package:dester/core/utils/app_logger.dart';
import 'package:dester/core/utils/url_helper.dart';

import 'check_connection.dart';


/// Implementation of check connection use case
class CheckConnectionImpl implements CheckConnection {
  final ConnectionRepository repository;

  CheckConnectionImpl(this.repository);

  @override
  Future<ConnectionGuardState> call() async {
    AppLogger.d('Checking API connection...');

    // Get active API URL
    final activeConfig = repository.getActiveApiConfiguration();
    final apiUrl = activeConfig?.url;

    if (apiUrl == null || apiUrl.isEmpty) {
      AppLogger.w('API URL not configured');
      return ConnectionGuardState(
        status: ConnectionStatus.error,
        errorMessage: 'API URL not configured',
        apiUrl: apiUrl,
      );
    }

    // Check API connection (normalize URL for better cross-platform compatibility)
    final normalizedUrl = UrlHelper.normalizeUrl(apiUrl);
    final status = await repository.checkApiConnection(normalizedUrl);

    String? errorMessage;
    if (status == ConnectionStatus.error) {
      errorMessage = 'Failed to connect to API';
      AppLogger.w('API connection failed: $errorMessage');
    } else {
      AppLogger.i('API connection check completed: $status');
    }

    return ConnectionGuardState(
      status: status,
      errorMessage: errorMessage,
      apiUrl: apiUrl,
    );
  }
}
