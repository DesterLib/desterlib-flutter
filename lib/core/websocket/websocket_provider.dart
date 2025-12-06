// Dart
import 'dart:async';

// External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/providers/connection_guard_provider.dart';

// Features
import 'package:dester/features/connection/domain/entities/connection_status.dart';

import 'websocket_service.dart';

// Export health data models for use in other files
export 'websocket_service.dart' show HealthHeartbeatData, HealthStatusData;

/// Scan progress state
class ScanProgressState {
  final bool isScanning;
  final ScanProgressPhase? phase;
  final int progress; // 0-100
  final int current;
  final int total;
  final String message;
  final String? libraryId;
  final String? scanJobId;
  final BatchItemComplete? batchItemComplete;
  final String? error;

  const ScanProgressState({
    this.isScanning = false,
    this.phase,
    this.progress = 0,
    this.current = 0,
    this.total = 0,
    this.message = '',
    this.libraryId,
    this.scanJobId,
    this.batchItemComplete,
    this.error,
  });

  ScanProgressState copyWith({
    bool? isScanning,
    ScanProgressPhase? phase,
    int? progress,
    int? current,
    int? total,
    String? message,
    String? libraryId,
    String? scanJobId,
    BatchItemComplete? batchItemComplete,
    String? error,
    bool clearError = false,
  }) {
    return ScanProgressState(
      isScanning: isScanning ?? this.isScanning,
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      current: current ?? this.current,
      total: total ?? this.total,
      message: message ?? this.message,
      libraryId: libraryId ?? this.libraryId,
      scanJobId: scanJobId ?? this.scanJobId,
      batchItemComplete: batchItemComplete ?? this.batchItemComplete,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// WebSocket service provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();

  // Dispose service when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// WebSocket connection state provider
/// Only connects when HTTP API is available
final webSocketConnectionProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(webSocketServiceProvider);

  // Watch connection guard to know when HTTP API is available
  ref.listen<ConnectionGuardState>(connectionGuardProvider, (previous, next) {
    if (next.status == ConnectionStatus.connected) {
      // HTTP API is connected - enable WebSocket connection
      service.enableConnection();
    } else if (next.status == ConnectionStatus.error) {
      // HTTP API is unavailable - disable WebSocket connection
      service.disableConnection();
    }
  });

  // Check initial connection state
  final connectionState = ref.read(connectionGuardProvider);
  if (connectionState.status == ConnectionStatus.connected) {
    service.enableConnection();
  } else {
    service.disableConnection();
  }

  return service.connectionStream;
});

/// Scan progress provider
final scanProgressProvider =
    NotifierProvider<ScanProgressNotifier, ScanProgressState>(() {
      return ScanProgressNotifier();
    });

/// Scan progress notifier
class ScanProgressNotifier extends Notifier<ScanProgressState> {
  StreamSubscription<WebSocketMessage>? _subscription;

  // Expose message stream for external listeners
  Stream<WebSocketMessage>? get messageStream {
    final service = ref.read(webSocketServiceProvider);
    return service.isConnected ? service.messageStream : null;
  }

  @override
  ScanProgressState build() {
    final service = ref.watch(webSocketServiceProvider);

    // WebSocket connection is managed by webSocketConnectionProvider
    // which coordinates with HTTP API connection status
    // Don't force connection here

    // Listen to WebSocket messages
    _subscription?.cancel();
    _subscription = service.messageStream.listen(
      _handleMessage,
      onError: (error) {
        state = state.copyWith(
          error: 'WebSocket error: $error',
          isScanning: false,
        );
      },
    );

    // Clean up subscription when notifier is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const ScanProgressState();
  }

  void _handleMessage(WebSocketMessage message) {
    switch (message.type) {
      case WebSocketMessageType.scanProgress:
        final progressData = ScanProgressData.fromJson(message.data);
        state = ScanProgressState(
          isScanning: true,
          phase: progressData.phase,
          progress: progressData.progress,
          current: progressData.current,
          total: progressData.total,
          message: progressData.message,
          libraryId: progressData.libraryId,
          scanJobId: progressData.scanJobId,
          batchItemComplete: progressData.batchItemComplete,
          error: null,
        );
        break;

      case WebSocketMessageType.scanComplete:
        final completeData = ScanCompleteData.fromJson(message.data);
        state = ScanProgressState(
          isScanning: false,
          phase: null,
          progress: 100,
          current: completeData.totalItems,
          total: completeData.totalItems,
          message: completeData.message,
          libraryId: completeData.libraryId,
          scanJobId: completeData.scanJobId,
          error: null,
        );
        break;

      case WebSocketMessageType.scanError:
        final errorData = ScanErrorData.fromJson(message.data);
        state = state.copyWith(isScanning: false, error: errorData.error);
        break;

      default:
        // Ignore other message types
        break;
    }
  }

  /// Clear scan progress
  void clear() {
    state = const ScanProgressState();
  }

  /// Get progress for a specific library
  ScanProgressState? getProgressForLibrary(String libraryId) {
    if (state.libraryId == libraryId && state.isScanning) {
      return state;
    }
    return null;
  }
}

/// Provider for active scan progress (latest scan)
final activeScanProgressProvider = Provider<ScanProgressState?>((ref) {
  final progress = ref.watch(scanProgressProvider);
  if (progress.isScanning) {
    return progress;
  }
  return null;
});

/// Health status state from WebSocket
class HealthStatusState {
  final String status; // 'healthy', 'degraded', 'unhealthy', 'unknown'
  final double uptime;
  final Map<String, String> services;
  final DateTime? lastUpdate;

  const HealthStatusState({
    this.status = 'unknown',
    this.uptime = 0.0,
    this.services = const {},
    this.lastUpdate,
  });

  HealthStatusState copyWith({
    String? status,
    double? uptime,
    Map<String, String>? services,
    DateTime? lastUpdate,
  }) {
    return HealthStatusState(
      status: status ?? this.status,
      uptime: uptime ?? this.uptime,
      services: services ?? this.services,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  bool get isHealthy => status == 'healthy';
  bool get isDegraded => status == 'degraded';
  bool get isUnhealthy => status == 'unhealthy';
  bool get isUnknown => status == 'unknown';
}

/// Health status provider that listens to WebSocket health events
final healthStatusProvider =
    NotifierProvider<HealthStatusNotifier, HealthStatusState>(() {
      return HealthStatusNotifier();
    });

/// Health status notifier
class HealthStatusNotifier extends Notifier<HealthStatusState> {
  StreamSubscription<WebSocketMessage>? _subscription;

  @override
  HealthStatusState build() {
    final service = ref.watch(webSocketServiceProvider);

    // Watch WebSocket connection state to reset health when disconnected
    ref.listen<AsyncValue<bool>>(webSocketConnectionProvider, (previous, next) {
      next.whenData((isConnected) {
        if (!isConnected) {
          // WebSocket disconnected - reset to unknown status
          state = const HealthStatusState(status: 'unknown');
        }
      });
    });

    // Listen to WebSocket messages for health updates
    _subscription?.cancel();
    _subscription = service.messageStream.listen(
      _handleMessage,
      onError: (error) {
        // Reset to unknown on error
        state = const HealthStatusState(status: 'unknown');
      },
    );

    // Clean up subscription when notifier is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const HealthStatusState();
  }

  void _handleMessage(WebSocketMessage message) {
    switch (message.type) {
      case WebSocketMessageType.healthHeartbeat:
        final heartbeat = HealthHeartbeatData.fromJson(message.data);
        state = state.copyWith(
          status: heartbeat.status,
          uptime: heartbeat.uptime,
          services: heartbeat.services,
          lastUpdate: DateTime.now(),
        );
        break;

      case WebSocketMessageType.healthStatus:
        final healthStatus = HealthStatusData.fromJson(message.data);
        state = state.copyWith(
          status: healthStatus.status,
          services: healthStatus.services,
          lastUpdate: DateTime.now(),
        );
        break;

      default:
        // Ignore other message types
        break;
    }
  }
}
