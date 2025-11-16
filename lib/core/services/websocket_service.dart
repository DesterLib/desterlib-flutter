import 'dart:async';
import 'dart:convert';
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
  final _logMessageController = StreamController<LogMessage>.broadcast();

  Stream<ScanProgressMessage> get scanProgressStream =>
      _scanProgressController.stream;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;
  Stream<LogMessage> get logMessageStream => _logMessageController.stream;

  bool get isConnected => _channel != null;

  /// Initialize WebSocket connection
  Future<void> connect(String baseUrl) async {
    if (_isConnecting) return;

    // If connecting to a different URL, close existing connection first
    if (_baseUrl != null && _baseUrl != baseUrl) {
      _shouldReconnect = false;
      _reconnectTimer?.cancel();
      await _channel?.sink.close();
      _channel = null;
    }

    _baseUrl = baseUrl;
    _isConnecting = true;
    _shouldReconnect = true;

    // Cancel any pending reconnect attempts
    _reconnectTimer?.cancel();

    try {
      // Convert HTTP URL to WebSocket URL
      final wsUrl = baseUrl
          .replaceFirst('http://', 'ws://')
          .replaceFirst('https://', 'wss://');

      _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/ws'));

      await _channel!.ready;

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
              scanJobId: data['scanJobId'] as String?,
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
              scanJobId: data['scanJobId'] as String?,
              phase: 'error',
              progress: 0,
              current: 0,
              total: 0,
              message: data['error'] as String? ?? 'Scan error',
            ),
          );
          break;
        case 'log:message':
          _logMessageController.add(LogMessage.fromJson(data));
          break;
        case 'connection:established':
          break;
        default:
          break;
      }
    } catch (e) {
      // Error parsing message
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    _connectionStateController.add(false);
  }

  /// Handle WebSocket disconnection
  void _handleDisconnect() {
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
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _scanProgressController.close();
    _connectionStateController.close();
    _logMessageController.close();
  }
}

/// Log message model
class LogMessage {
  final String level;
  final String message;
  final String timestamp;
  final Map<String, dynamic>? meta;

  const LogMessage({
    required this.level,
    required this.message,
    required this.timestamp,
    this.meta,
  });

  factory LogMessage.fromJson(Map<String, dynamic> json) {
    return LogMessage(
      level: json['level'] as String? ?? 'info',
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }

  /// Get color based on log level
  String get levelColor {
    switch (level.toLowerCase()) {
      case 'error':
        return 'red';
      case 'warn':
        return 'yellow';
      case 'info':
        return 'green';
      case 'http':
        return 'magenta';
      case 'debug':
        return 'blue';
      default:
        return 'white';
    }
  }
}

/// Batch item complete information
class BatchItemComplete {
  final String folderName;
  final int itemsSaved;
  final int totalItems;

  const BatchItemComplete({
    required this.folderName,
    required this.itemsSaved,
    required this.totalItems,
  });

  factory BatchItemComplete.fromJson(Map<String, dynamic> json) {
    return BatchItemComplete(
      folderName: json['folderName'] as String? ?? '',
      itemsSaved: (json['itemsSaved'] as num?)?.toInt() ?? 0,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Scan progress message model
class ScanProgressMessage {
  final String? libraryId;
  final String? scanJobId;
  final String phase;
  final int progress;
  final int current;
  final int total;
  final String message;
  final BatchItemComplete? batchItemComplete;

  const ScanProgressMessage({
    this.libraryId,
    this.scanJobId,
    required this.phase,
    required this.progress,
    required this.current,
    required this.total,
    required this.message,
    this.batchItemComplete,
  });

  factory ScanProgressMessage.fromJson(Map<String, dynamic> json) {
    BatchItemComplete? batchItem;
    if (json['batchItemComplete'] != null) {
      batchItem = BatchItemComplete.fromJson(
        json['batchItemComplete'] as Map<String, dynamic>,
      );
    }

    return ScanProgressMessage(
      libraryId: json['libraryId'] as String?,
      scanJobId: json['scanJobId'] as String?,
      phase: json['phase'] as String? ?? 'unknown',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      current: (json['current'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      batchItemComplete: batchItem,
    );
  }

  bool get isComplete => phase == 'complete';
  bool get isError => phase == 'error';
  bool get isBatchComplete => phase == 'batch-complete';
  bool get isDiscovering => phase == 'discovering';
  bool get isBatching => phase == 'batching';
  bool get isScanning =>
      phase == 'scanning' ||
      phase == 'fetching-metadata' ||
      phase == 'fetching-episodes' ||
      phase == 'saving' ||
      phase == 'discovering' ||
      phase == 'batching';

  double get progressPercent => progress / 100.0;
}
