import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../storage/preferences_service.dart';

/// Connection status enum
enum ConnectionStatus { connected, disconnected, checking, error }

/// Service for checking API connection status
class ConnectionGuard {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectionStatus _status = ConnectionStatus.checking;
  String? _errorMessage;

  ConnectionStatus get status => _status;
  String? get errorMessage => _errorMessage;

  final StreamController<ConnectionStatus> _statusController =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  /// Initialize the connection guard
  Future<void> init() async {
    // Start listening to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _checkConnection();
    });

    // Initial check
    await _checkConnection();
  }

  /// Check the API connection
  Future<void> _checkConnection() async {
    _status = ConnectionStatus.checking;
    _statusController.add(_status);

    // First check if device has internet connectivity
    final connectivityResults = await _connectivity.checkConnectivity();
    final hasInternet = connectivityResults.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );

    if (!hasInternet) {
      _status = ConnectionStatus.disconnected;
      _errorMessage = 'No internet connection';
      _statusController.add(_status);
      return;
    }

    // Get API URL from preferences
    final apiUrl = PreferencesService.getApiBaseUrl();

    if (apiUrl == null || apiUrl.isEmpty) {
      _status = ConnectionStatus.error;
      _errorMessage = 'API URL not configured';
      _statusController.add(_status);
      return;
    }

    // Try to connect to the API
    try {
      final uri = Uri.parse(apiUrl);
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode >= 200 && response.statusCode < 500) {
        _status = ConnectionStatus.connected;
        _errorMessage = null;
      } else {
        _status = ConnectionStatus.error;
        _errorMessage = 'API returned status code: ${response.statusCode}';
      }
    } catch (e) {
      _status = ConnectionStatus.error;
      _errorMessage = 'Failed to connect: ${e.toString()}';
    }

    _statusController.add(_status);
  }

  /// Manually trigger a connection check
  Future<void> checkConnection() async {
    await _checkConnection();
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _statusController.close();
  }
}
