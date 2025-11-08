import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:dester/app/providers.dart';

class ConnectionStatusNotifier extends Notifier<ConnectionStatus> {
  bool _disposed = false;
  int _checkCounter = 0;

  @override
  ConnectionStatus build() {
    _disposed = false;
    _checkCounter = 0;

    // Register disposal callback
    ref.onDispose(() {
      _disposed = true;
    });

    // Schedule the initial check after the first frame is painted
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) {
        _checkConnection();
      }
    });

    return ConnectionStatus.checking;
  }

  Future<ConnectionStatus> _checkConnection() async {
    if (_disposed) return state;

    // Increment counter to invalidate previous checks
    final currentCheck = ++_checkCounter;

    try {
      final client = ref.read(openapiClientProvider);
      final healthApi = client.getHealthApi();

      // Add timeout to prevent indefinite blocking
      await healthApi.healthGet().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      // Only update state if this is still the latest check
      if (!_disposed && currentCheck == _checkCounter) {
        state = ConnectionStatus.connected;
        return ConnectionStatus.connected;
      }
      return state;
    } catch (e) {
      // Only update state if this is still the latest check
      if (!_disposed && currentCheck == _checkCounter) {
        state = ConnectionStatus.disconnected;
        return ConnectionStatus.disconnected;
      }
      return state;
    }
  }

  Future<ConnectionStatus> checkConnection() async {
    if (_disposed) return state;

    // Invalidate any ongoing checks
    _checkCounter++;
    state = ConnectionStatus.checking;

    // Wait for next frame before making call
    await SchedulerBinding.instance.endOfFrame;

    if (_disposed) {
      return state;
    }

    return await _checkConnection();
  }

  void setDisconnected() {
    if (!_disposed) {
      state = ConnectionStatus.disconnected;
    }
  }

  void setConnected() {
    if (!_disposed) {
      state = ConnectionStatus.connected;
    }
  }
}

enum ConnectionStatus { checking, connected, disconnected }

// Provider for connection status
final connectionStatusProvider =
    NotifierProvider<ConnectionStatusNotifier, ConnectionStatus>(() {
      return ConnectionStatusNotifier();
    });
