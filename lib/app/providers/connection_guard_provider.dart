// Dart
import 'dart:async';

// External packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core
import 'package:dester/core/connection/connection_service.dart';
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/connection/domain/entities/connection_status.dart';
import 'package:dester/core/storage/preferences_service.dart';


/// Provider for PreferencesService initialization
final preferencesServiceProvider = FutureProvider<void>((ref) async {
  await PreferencesService.init();
});

/// Provider for ConnectionGuard state
final connectionGuardProvider =
    NotifierProvider<ConnectionGuardNotifier, ConnectionGuardState>(
      ConnectionGuardNotifier.new,
    );

/// Notifier for managing connection guard state (presentation layer)
class ConnectionGuardNotifier extends Notifier<ConnectionGuardState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _debounceTimer;
  bool _isInitialized = false;
  bool _isCheckingConnection = false;
  Future<void>? _currentCheck;

  // Use cases (injected via service factory)
  late final _checkConnection = ConnectionService.createCheckConnection();
  late final _addApiConfiguration =
      ConnectionService.createAddApiConfiguration();
  late final _setActiveApiConfiguration =
      ConnectionService.createSetActiveApiConfiguration();
  late final _deleteApiConfiguration =
      ConnectionService.createDeleteApiConfiguration();
  late final _getApiConfigurations =
      ConnectionService.createGetApiConfigurations();

  @override
  ConnectionGuardState build() {
    // Ensure preferences are initialized
    ref.watch(preferencesServiceProvider);

    // Get initial API URL from active configuration
    final apiUrl = PreferencesService.getActiveApiUrl();

    // Clean up on dispose
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
      _debounceTimer?.cancel();
      _currentCheck = null;
      _isCheckingConnection = false;
    });

    // Initialize only once after build
    if (!_isInitialized) {
      _isInitialized = true;
      Future.microtask(() => init());
    }

    return ConnectionGuardState(
      status: ConnectionStatus.checking,
      apiUrl: apiUrl,
    );
  }

  /// Initialize the connection guard
  Future<void> init() async {
    // Start listening to connectivity changes with debouncing
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Debounce connectivity changes to avoid rapid-fire checks
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        checkConnection();
      });
    });

    // Initial check
    await checkConnection();
  }

  /// Check the API connection using use case
  /// Prevents multiple simultaneous checks
  Future<void> checkConnection() async {
    // If a check is already in progress, wait for it to complete
    if (_isCheckingConnection && _currentCheck != null) {
      return _currentCheck;
    }

    // Create a new check
    _currentCheck = _performCheck();
    try {
      await _currentCheck;
    } finally {
      _currentCheck = null;
      _isCheckingConnection = false;
    }
  }

  /// Internal method to perform the actual connection check
  Future<void> _performCheck() async {
    _isCheckingConnection = true;
    
    state = state.copyWith(
      status: ConnectionStatus.checking,
      clearErrorMessage: true,
    );

    final result = await _checkConnection();
    state = result;
  }

  /// Add a new API configuration
  Future<void> addApiConfiguration(
    String url,
    String label, {
    bool setAsActive = false,
  }) async {
    final result = await _addApiConfiguration(
      url,
      label,
      setAsActive: setAsActive,
    );
    state = result;
  }

  /// Set an API configuration as active
  Future<void> setActiveApiConfiguration(String configurationId) async {
    final result = await _setActiveApiConfiguration(configurationId);
    state = result;
  }

  /// Delete an API configuration
  Future<void> deleteApiConfiguration(String configurationId) async {
    final result = await _deleteApiConfiguration(configurationId);
    state = result;
  }

  /// Get all API configurations
  List<ApiConfiguration> getApiConfigurations() {
    return _getApiConfigurations();
  }
}
