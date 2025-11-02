import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:dester/app/providers.dart';

class ConnectionStatusNotifier extends Notifier<ConnectionStatus> {
  @override
  ConnectionStatus build() {
    // Schedule the check after the first frame is painted
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkConnection();
    });
    return ConnectionStatus.checking;
  }

  Future<void> _checkConnection() async {
    try {
      final client = ref.read(openapiClientProvider);
      final healthApi = client.getHealthApi();

      // Add timeout to prevent indefinite blocking
      await healthApi.healthGet().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      state = ConnectionStatus.connected;
    } catch (e) {
      state = ConnectionStatus.disconnected;
    }
  }

  Future<void> checkConnection() async {
    state = ConnectionStatus.checking;
    // Wait for next frame before making call
    await SchedulerBinding.instance.endOfFrame;
    await _checkConnection();
  }

  void setDisconnected() {
    state = ConnectionStatus.disconnected;
  }

  void setConnected() {
    state = ConnectionStatus.connected;
  }
}

enum ConnectionStatus { checking, connected, disconnected }

// Provider for connection status
final connectionStatusProvider =
    NotifierProvider<ConnectionStatusNotifier, ConnectionStatus>(() {
      return ConnectionStatusNotifier();
    });
