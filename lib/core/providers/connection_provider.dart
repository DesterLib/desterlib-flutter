import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import '../config/api_config.dart';

class ConnectionStatusNotifier extends Notifier<ConnectionStatus> {
  @override
  ConnectionStatus build() {
    _checkConnection();
    return ConnectionStatus.checking;
  }

  Future<void> _checkConnection() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.get(ApiConfig.healthUrl);
      state = ConnectionStatus.connected;
    } catch (e) {
      state = ConnectionStatus.disconnected;
    }
  }

  Future<void> checkConnection() async {
    state = ConnectionStatus.checking;
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
