// Core
import 'package:dester/core/storage/preferences_service.dart';

/// Utility class for checking API configuration status
class ApiConfigHelper {
  /// Check if an API is configured
  /// Returns true if there's an active API URL configured, false otherwise
  static bool isApiConfigured() {
    final apiUrl = PreferencesService.getActiveApiUrl();
    return apiUrl != null && apiUrl.isNotEmpty;
  }
}
