import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/websocket_service.dart';
import '../../app/providers.dart';

/// WebSocket service provider
final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();

  // Auto-connect when baseUrl changes
  ref.listen(baseUrlProvider, (previous, next) {
    // Disconnect from old URL first, then connect to new URL
    if (previous != null && previous != next) {
      service.disconnect();
    }
    service.connect(next);
  });

  // Initial connection
  final baseUrl = ref.read(baseUrlProvider);
  service.connect(baseUrl);

  // Cleanup on dispose
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Scan progress state model
class ScanProgressState {
  final Map<String, ScanProgressMessage> libraryProgress;
  final bool isConnected;

  const ScanProgressState({
    this.libraryProgress = const {},
    this.isConnected = false,
  });

  ScanProgressState copyWith({
    Map<String, ScanProgressMessage>? libraryProgress,
    bool? isConnected,
  }) {
    return ScanProgressState(
      libraryProgress: libraryProgress ?? this.libraryProgress,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  /// Get progress for a specific library
  ScanProgressMessage? getProgress(String libraryId) {
    return libraryProgress[libraryId];
  }

  /// Check if any library is currently scanning
  bool get hasActiveScans {
    return libraryProgress.values.any((progress) => progress.isScanning);
  }
}

/// Scan progress notifier
class ScanProgressNotifier extends Notifier<ScanProgressState> {
  @override
  ScanProgressState build() {
    final service = ref.watch(websocketServiceProvider);

    // Listen to scan progress messages
    service.scanProgressStream.listen((message) {
      if (message.libraryId != null) {
        final newProgress = Map<String, ScanProgressMessage>.from(
          state.libraryProgress,
        );

        if (message.isComplete || message.isError) {
          // Remove completed/errored scans after 3 seconds
          newProgress[message.libraryId!] = message;
          state = state.copyWith(libraryProgress: newProgress);

          Future.delayed(const Duration(seconds: 3), () {
            final currentProgress = Map<String, ScanProgressMessage>.from(
              state.libraryProgress,
            );
            currentProgress.remove(message.libraryId);
            state = state.copyWith(libraryProgress: currentProgress);
          });
        } else {
          newProgress[message.libraryId!] = message;
          state = state.copyWith(libraryProgress: newProgress);
        }
      }
    });

    // Listen to connection state
    service.connectionStateStream.listen((isConnected) {
      state = state.copyWith(isConnected: isConnected);
    });

    return const ScanProgressState();
  }

  /// Clear progress for a specific library
  void clearProgress(String libraryId) {
    final newProgress = Map<String, ScanProgressMessage>.from(
      state.libraryProgress,
    );
    newProgress.remove(libraryId);
    state = state.copyWith(libraryProgress: newProgress);
  }

  /// Clear all progress
  void clearAll() {
    state = state.copyWith(libraryProgress: {});
  }
}

/// Scan progress provider
final scanProgressProvider =
    NotifierProvider<ScanProgressNotifier, ScanProgressState>(() {
      return ScanProgressNotifier();
    });
