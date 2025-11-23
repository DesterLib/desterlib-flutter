// Dart
import 'dart:async';

// External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'websocket_service.dart';


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
final webSocketConnectionProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(webSocketServiceProvider);

  // Auto-connect when provider is created
  service.connect();

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

    // Ensure WebSocket is connected
    if (!service.isConnected) {
      service.connect().catchError((error) {
        // Connection will be handled by the service
      });
    }

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
