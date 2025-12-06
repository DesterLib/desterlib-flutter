// External packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'app_logger.dart';

/// Helper class for connection-related operations
class ConnectionHelper {
  /// Add a new API configuration
  /// Requires a WidgetRef to access the provider
  static Future<bool> addApiConfiguration(
    String url,
    String label,
    WidgetRef ref, {
    bool setAsActive = false,
  }) async {
    try {
      AppLogger.d('Adding API configuration: $label - $url');
      await ref
          .read(connectionGuardProvider.notifier)
          .addApiConfiguration(url, label, setAsActive: setAsActive);
      AppLogger.i('API configuration added successfully');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Error adding API configuration', e, stackTrace);
      return false;
    }
  }

  /// Get the current API URL
  static String? getApiUrl(WidgetRef ref) {
    return ref.read(connectionGuardProvider).apiUrl;
  }

  /// Navigate to manage APIs page (connection status is shown via icon)
  static void showConnectionStatus(BuildContext context) {
    context.go('/settings/manage-apis');
  }

  /// Delete an API configuration
  static Future<void> deleteApiConfiguration(
    String configurationId,
    WidgetRef ref,
  ) async {
    await ref
        .read(connectionGuardProvider.notifier)
        .deleteApiConfiguration(configurationId);
  }

  /// Check connection manually
  static Future<void> checkConnection(WidgetRef ref) async {
    await ref.read(connectionGuardProvider.notifier).checkConnection();
  }
}
