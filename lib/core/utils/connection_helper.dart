import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers/connection_guard_provider.dart';
import '../connection/presentation/widgets/connection_status_modal.dart';
import 'app_logger.dart';

/// Helper class for connection-related operations
class ConnectionHelper {
  /// Set the API base URL and check connection
  /// Requires a WidgetRef to access the provider
  static Future<bool> setApiUrl(String url, WidgetRef ref) async {
    try {
      AppLogger.d('Setting API URL: $url');
      await ref.read(connectionGuardProvider.notifier).setApiUrl(url);
      AppLogger.i('API URL set successfully');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Error setting API URL', e, stackTrace);
      return false;
    }
  }

  /// Get the current API URL
  static String? getApiUrl(WidgetRef ref) {
    return ref.read(connectionGuardProvider).apiUrl;
  }

  /// Show connection status modal/drawer
  static void showConnectionStatus(BuildContext context) {
    ConnectionStatusModal.show(context);
  }

  /// Clear the stored API URL
  static Future<void> clearApiUrl(WidgetRef ref) async {
    await ref.read(connectionGuardProvider.notifier).clearApiUrl();
  }

  /// Check connection manually
  static Future<void> checkConnection(WidgetRef ref) async {
    await ref.read(connectionGuardProvider.notifier).checkConnection();
  }
}
