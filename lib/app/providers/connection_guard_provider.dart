import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/preferences_service.dart';
import '../../features/connection/connection_feature.dart';
import '../../features/connection/domain/entities/connection_status.dart';

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

  // Use cases (injected via feature factory)
  late final _checkConnection = ConnectionFeature.createCheckConnection();
  late final _setApiUrl = ConnectionFeature.createSetApiUrl();
  late final _clearApiUrl = ConnectionFeature.createClearApiUrl();

  @override
  ConnectionGuardState build() {
    // Ensure preferences are initialized
    ref.watch(preferencesServiceProvider);

    // Get initial API URL
    final apiUrl = PreferencesService.getApiBaseUrl();

    // Clean up on dispose
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });

    // Initialize after build
    Future.microtask(() => init());

    return ConnectionGuardState(
      status: ConnectionStatus.checking,
      apiUrl: apiUrl,
    );
  }

  /// Initialize the connection guard
  Future<void> init() async {
    // Start listening to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      checkConnection();
    });

    // Initial check
    await checkConnection();
  }

  /// Check the API connection using use case
  Future<void> checkConnection() async {
    state = state.copyWith(
      status: ConnectionStatus.checking,
      clearErrorMessage: true,
    );

    final result = await _checkConnection();
    state = result;
  }

  /// Update API URL using use case
  Future<void> setApiUrl(String url) async {
    final result = await _setApiUrl(url);
    state = result;
  }

  /// Clear the stored API URL using use case
  Future<void> clearApiUrl() async {
    final result = await _clearApiUrl();
    state = result;
  }
}
