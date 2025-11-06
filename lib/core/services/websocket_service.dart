import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket service for real-time server updates
class WebSocketService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  bool _shouldReconnect = true;
  String? _baseUrl;

  final _scanProgressController =
      StreamController<ScanProgressMessage>.broadcast();
  final _connectionStateController = StreamController<bool>.broadcast();

  Stream<ScanProgressMessage> get scanProgressStream =>
      _scanProgressController.stream;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  bool get isConnected => _channel != null;

  /// Initialize WebSocket connection
  Future<void> connect(String baseUrl) async {
    if (_isConnecting) return;

    _baseUrl = baseUrl;
    _isConnecting = true;
    _shouldReconnect = true;

    try {
      // Convert HTTP URL to WebSocket URL
      final wsUrl = baseUrl
          .replaceFirst('http://', 'ws://')
          .replaceFirst('https://', 'wss://');

      debugPrint('🔌 Connecting to WebSocket: $wsUrl/ws');

      _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/ws'));

      await _channel!.ready;

      debugPrint('✅ WebSocket connected');
      _connectionStateController.add(true);
      _isConnecting = false;

      // Listen to messages
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('❌ WebSocket connection error: $e');
      _isConnecting = false;
      _connectionStateController.add(false);
      _scheduleReconnect();
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      switch (type) {
        case 'scan:progress':
          // Backend sends the data directly, not nested in 'data'
          _scanProgressController.add(ScanProgressMessage.fromJson(data));
          break;
        case 'scan:complete':
          _scanProgressController.add(
            ScanProgressMessage(
              libraryId: data['libraryId'] as String?,
              phase: 'complete',
              progress: 100,
              current: data['totalItems'] as int? ?? 0,
              total: data['totalItems'] as int? ?? 0,
              message: data['message'] as String? ?? 'Scan complete',
            ),
          );
          break;
        case 'scan:error':
          _scanProgressController.add(
            ScanProgressMessage(
              libraryId: data['libraryId'] as String?,
              phase: 'error',
              progress: 0,
              current: 0,
              total: 0,
              message: data['error'] as String? ?? 'Scan error',
            ),
          );
          break;
        case 'connection:established':
          debugPrint('📨 ${data['message']}');
          break;
        default:
          debugPrint('📨 Unknown WebSocket message type: $type');
      }
    } catch (e) {
      debugPrint('❌ Error parsing WebSocket message: $e');
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    debugPrint('❌ WebSocket error: $error');
    _connectionStateController.add(false);
  }

  /// Handle WebSocket disconnection
  void _handleDisconnect() {
    debugPrint('🔌 WebSocket disconnected');
    _channel = null;
    _connectionStateController.add(false);

    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_baseUrl != null && _shouldReconnect) {
        debugPrint('🔄 Attempting to reconnect WebSocket...');
        connect(_baseUrl!);
      }
    });
  }

  /// Disconnect WebSocket
  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _connectionStateController.add(false);
    debugPrint('👋 WebSocket disconnected');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _scanProgressController.close();
    _connectionStateController.close();
  }
}

/// Scan progress message model
class ScanProgressMessage {
  final String? libraryId;
  final String phase;
  final int progress;
  final int current;
  final int total;
  final String message;

  const ScanProgressMessage({
    this.libraryId,
    required this.phase,
    required this.progress,
    required this.current,
    required this.total,
    required this.message,
  });

  factory ScanProgressMessage.fromJson(Map<String, dynamic> json) {
    return ScanProgressMessage(
      libraryId: json['libraryId'] as String?,
      phase: json['phase'] as String? ?? 'unknown',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      current: (json['current'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
    );
  }

  bool get isComplete => phase == 'complete';
  bool get isError => phase == 'error';
  bool get isScanning =>
      phase == 'scanning' ||
      phase == 'fetching-metadata' ||
      phase == 'fetching-episodes' ||
      phase == 'saving';

  double get progressPercent => progress / 100.0;
}
