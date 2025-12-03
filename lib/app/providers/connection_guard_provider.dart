// Dart
import 'dart:async';

// External packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core
import 'package:dester/core/storage/preferences_service.dart';
import 'package:dester/core/websocket/websocket_provider.dart';

// Features
import 'package:dester/features/connection/connection_feature.dart';
import 'package:dester/features/connection/domain/entities/api_configuration.dart';
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/features/home/presentation/controllers/home_controller.dart';
import 'package:dester/features/settings/presentation/providers/manage_libraries_providers.dart';

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
  Timer? _wsDisconnectTimer;
  bool _isInitialized = false;
  bool _isCheckingConnection = false;
  Future<void>? _currentCheck;
  bool _wasWsConnected = false;

  // Use cases (injected via feature factory)
  late final _checkConnection = ConnectionFeature.createCheckConnection();
  late final _addApiConfiguration =
      ConnectionFeature.createAddApiConfiguration();
  late final _setActiveApiConfiguration =
      ConnectionFeature.createSetActiveApiConfiguration();
  late final _deleteApiConfiguration =
      ConnectionFeature.createDeleteApiConfiguration();
  late final _getApiConfigurations =
      ConnectionFeature.createGetApiConfigurations();

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
      _wsDisconnectTimer?.cancel();
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

    // Start listening to WebSocket connection state
    _startWebSocketMonitoring();

    // Initial check
    await checkConnection();
  }

  /// Monitor WebSocket connection state for disconnections
  void _startWebSocketMonitoring() {
    // Use ref.listen to react to WebSocket connection changes
    ref.listen<AsyncValue<bool>>(webSocketConnectionProvider, (previous, next) {
      next.whenData((isConnected) {
        // If WebSocket connects, mark it
        if (isConnected) {
          _wasWsConnected = true;
          _wsDisconnectTimer?.cancel();
          return;
        }

        // If WebSocket disconnects after being connected, wait a bit then check
        // This handles temporary network issues vs. server being down
        if (_wasWsConnected && !isConnected) {
          _wsDisconnectTimer?.cancel();
          _wsDisconnectTimer = Timer(const Duration(seconds: 5), () {
            // If still disconnected after 5 seconds, verify connection
            checkConnection();
          });
        }
      });

      // Handle WebSocket errors
      next.whenOrNull(
        error: (error, stackTrace) {
          // WebSocket error - check connection status
          _wsDisconnectTimer?.cancel();
          _wsDisconnectTimer = Timer(const Duration(seconds: 2), () {
            checkConnection();
          });
        },
      );
    });
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
  /// This will invalidate content providers to trigger a refetch
  Future<void> setActiveApiConfiguration(String configurationId) async {
    final result = await _setActiveApiConfiguration(configurationId);
    state = result;

    // If successfully connected, invalidate content providers to refetch data
    if (result.status == ConnectionStatus.connected) {
      _invalidateContentProviders();
    }
  }

  /// Invalidate all content providers to trigger a refetch
  /// Called when the active server changes
  void _invalidateContentProviders() {
    // Invalidate home controller to refetch movies and TV shows
    ref.invalidate(homeControllerProvider);

    // Invalidate manage libraries controller to refetch libraries
    ref.invalidate(manageLibrariesControllerProvider);
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
