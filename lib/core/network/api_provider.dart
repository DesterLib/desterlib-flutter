import 'dester_api.dart';
import '../storage/preferences_service.dart';

/// Global API provider - simple singleton for the DesterApi instance
class ApiProvider {
  static DesterApi? _instance;

  /// Get the current API instance
  /// Throws if not initialized
  static DesterApi get instance {
    if (_instance == null) {
      // Try to initialize with saved URL
      final url = PreferencesService.getActiveApiUrl();
      if (url != null && url.isNotEmpty) {
        initialize(url);
      } else {
        throw StateError(
          'API not initialized. Call ApiProvider.initialize() first.',
        );
      }
    }
    return _instance!;
  }

  /// Check if API is initialized
  static bool get isInitialized => _instance != null;

  /// Initialize or update the API with a new base URL
  static void initialize(String baseUrl) {
    // Dispose old instance if exists
    _instance?.dispose();

    // Create new instance
    _instance = DesterApi(
      baseUrl: baseUrl,
      timeout: const Duration(seconds: 30),
    );
  }

  /// Update just the base URL (for when user switches servers)
  static void updateBaseUrl(String newBaseUrl) {
    if (_instance != null) {
      _instance!.updateBaseUrl(newBaseUrl);
    } else {
      initialize(newBaseUrl);
    }
  }

  /// Dispose the API client
  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }
}
