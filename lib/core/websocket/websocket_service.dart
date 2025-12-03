// Dart
import 'dart:async';
import 'dart:convert';

// External packages
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

// Core
import 'package:dester/core/storage/preferences_service.dart';
import 'package:dester/core/utils/app_logger.dart';
import 'package:dester/core/utils/url_helper.dart';

/// WebSocket message types from backend
enum WebSocketMessageType {
  connectionEstablished,
  healthHeartbeat,
  healthStatus,
  healthDegraded,
  scanProgress,
  scanComplete,
  scanError,
  logMessage,
  unknown,
}

/// Scan progress phase
enum ScanProgressPhase {
  scanning,
  fetchingMetadata,
  fetchingEpisodes,
  saving,
  discovering,
  batching,
  batchComplete,
  unknown,
}

/// WebSocket message models
class WebSocketMessage {
  final WebSocketMessageType type;
  final Map<String, dynamic> data;

  WebSocketMessage({required this.type, required this.data});

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    final messageType = json['type'] as String?;
    WebSocketMessageType type = WebSocketMessageType.unknown;

    switch (messageType) {
      case 'connection:established':
        type = WebSocketMessageType.connectionEstablished;
        break;
      case 'health:heartbeat':
        type = WebSocketMessageType.healthHeartbeat;
        break;
      case 'health:status':
        type = WebSocketMessageType.healthStatus;
        break;
      case 'health:degraded':
        type = WebSocketMessageType.healthDegraded;
        break;
      case 'scan:progress':
        type = WebSocketMessageType.scanProgress;
        break;
      case 'scan:complete':
        type = WebSocketMessageType.scanComplete;
        break;
      case 'scan:error':
        type = WebSocketMessageType.scanError;
        break;
      case 'log:message':
        type = WebSocketMessageType.logMessage;
        break;
    }

    return WebSocketMessage(type: type, data: json);
  }
}

/// Health heartbeat data from WebSocket
class HealthHeartbeatData {
  final double uptime;
  final String status; // 'healthy', 'degraded', 'unhealthy'
  final Map<String, String> services;

  HealthHeartbeatData({
    required this.uptime,
    required this.status,
    required this.services,
  });

  factory HealthHeartbeatData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return HealthHeartbeatData(
      uptime: (data['uptime'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'unknown',
      services: Map<String, String>.from(data['services'] as Map? ?? {}),
    );
  }

  bool get isHealthy => status == 'healthy';
  bool get isDegraded => status == 'degraded';
  bool get isUnhealthy => status == 'unhealthy';
}

/// Health status change data from WebSocket
class HealthStatusData {
  final String status; // 'healthy', 'degraded', 'unhealthy'
  final String message;
  final Map<String, String>? services;

  HealthStatusData({
    required this.status,
    required this.message,
    this.services,
  });

  factory HealthStatusData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return HealthStatusData(
      status: data['status'] as String? ?? 'unknown',
      message: data['message'] as String? ?? '',
      services: data['services'] != null
          ? Map<String, String>.from(data['services'] as Map)
          : null,
    );
  }

  bool get isHealthy => status == 'healthy';
  bool get isDegraded => status == 'degraded';
  bool get isUnhealthy => status == 'unhealthy';
}

class ScanProgressData {
  final ScanProgressPhase phase;
  final int progress; // 0-100
  final int current;
  final int total;
  final String message;
  final String? libraryId;
  final String? scanJobId;
  final BatchItemComplete? batchItemComplete;

  ScanProgressData({
    required this.phase,
    required this.progress,
    required this.current,
    required this.total,
    required this.message,
    this.libraryId,
    this.scanJobId,
    this.batchItemComplete,
  });

  factory ScanProgressData.fromJson(Map<String, dynamic> json) {
    final phaseStr = json['phase'] as String?;
    ScanProgressPhase phase = ScanProgressPhase.unknown;

    switch (phaseStr) {
      case 'scanning':
        phase = ScanProgressPhase.scanning;
        break;
      case 'fetching-metadata':
        phase = ScanProgressPhase.fetchingMetadata;
        break;
      case 'fetching-episodes':
        phase = ScanProgressPhase.fetchingEpisodes;
        break;
      case 'saving':
        phase = ScanProgressPhase.saving;
        break;
      case 'discovering':
        phase = ScanProgressPhase.discovering;
        break;
      case 'batching':
        phase = ScanProgressPhase.batching;
        break;
      case 'batch-complete':
        phase = ScanProgressPhase.batchComplete;
        break;
    }

    return ScanProgressData(
      phase: phase,
      progress: json['progress'] as int? ?? 0,
      current: json['current'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      libraryId: json['libraryId'] as String?,
      scanJobId: json['scanJobId'] as String?,
      batchItemComplete: json['batchItemComplete'] != null
          ? BatchItemComplete.fromJson(
              json['batchItemComplete'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class BatchItemComplete {
  final String folderName;
  final int itemsSaved;
  final int totalItems;

  BatchItemComplete({
    required this.folderName,
    required this.itemsSaved,
    required this.totalItems,
  });

  factory BatchItemComplete.fromJson(Map<String, dynamic> json) {
    return BatchItemComplete(
      folderName: json['folderName'] as String? ?? '',
      itemsSaved: json['itemsSaved'] as int? ?? 0,
      totalItems: json['totalItems'] as int? ?? 0,
    );
  }
}

class ScanCompleteData {
  final String libraryId;
  final int totalItems;
  final String message;
  final String? scanJobId;

  ScanCompleteData({
    required this.libraryId,
    required this.totalItems,
    required this.message,
    this.scanJobId,
  });

  factory ScanCompleteData.fromJson(Map<String, dynamic> json) {
    return ScanCompleteData(
      libraryId: json['libraryId'] as String? ?? '',
      totalItems: json['totalItems'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      scanJobId: json['scanJobId'] as String?,
    );
  }
}

class ScanErrorData {
  final String? libraryId;
  final String? scanJobId;
  final String error;

  ScanErrorData({this.libraryId, this.scanJobId, required this.error});

  factory ScanErrorData.fromJson(Map<String, dynamic> json) {
    return ScanErrorData(
      libraryId: json['libraryId'] as String?,
      scanJobId: json['scanJobId'] as String?,
      error: json['error'] as String? ?? '',
    );
  }
}

/// WebSocket service for real-time updates
class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const Duration _initialReconnectDelay = Duration(seconds: 1);
  final _connectionController = StreamController<bool>.broadcast();
  final _messageController = StreamController<WebSocketMessage>.broadcast();

  /// Connection state stream
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Message stream
  Stream<WebSocketMessage> get messageStream => _messageController.stream;

  /// Check if currently connected
  bool get isConnected => _isConnected;

  /// Connect to WebSocket server
  Future<void> connect() async {
    if (_isConnected && _channel != null) {
      AppLogger.d('WebSocket already connected');
      return;
    }

    try {
      // Get base URL from preferences
      final baseUrl =
          PreferencesService.getActiveApiUrl() ?? 'http://localhost:3001';
      final normalizedUrl = UrlHelper.normalizeUrl(baseUrl);

      // Convert HTTP/HTTPS URL to WebSocket URL
      final wsUrl = normalizedUrl
          .replaceFirst('http://', 'ws://')
          .replaceFirst('https://', 'wss://');
      final wsUri = Uri.parse('$wsUrl/ws');

      AppLogger.i('Connecting to WebSocket: $wsUri');

      _channel = WebSocketChannel.connect(wsUri);

      // Listen to messages
      _subscription = _channel!.stream.listen(
        (message) {
          try {
            if (message is String) {
              final json = jsonDecode(message) as Map<String, dynamic>;
              final wsMessage = WebSocketMessage.fromJson(json);

              // Handle connection established
              if (wsMessage.type ==
                  WebSocketMessageType.connectionEstablished) {
                AppLogger.i('WebSocket connection established');
                _isConnected = true;
                _connectionController.add(true);
              }

              // Only log non-heartbeat messages to reduce noise
              if (wsMessage.type != WebSocketMessageType.healthHeartbeat) {
                AppLogger.d('WebSocket message received: ${wsMessage.type}');
              }

              _messageController.add(wsMessage);
            }
          } catch (e, stackTrace) {
            AppLogger.e('Error parsing WebSocket message: $e', e, stackTrace);
          }
        },
        onError: (error) {
          AppLogger.e('WebSocket error: $error', error);
          _isConnected = false;
          _connectionController.add(false);
          _scheduleReconnect();
        },
        onDone: () {
          AppLogger.w('WebSocket connection closed');
          _isConnected = false;
          _connectionController.add(false);
          _scheduleReconnect();
        },
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempts = 0; // Reset on successful connection
      _connectionController.add(true);
      AppLogger.i('WebSocket connected successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to connect WebSocket: $e', e, stackTrace);
      _isConnected = false;
      _connectionController.add(false);
      _scheduleReconnect();
      rethrow;
    }
  }

  /// Schedule automatic reconnection with exponential backoff
  void _scheduleReconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) {
      return; // Already scheduled
    }

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      AppLogger.w(
        'Max reconnection attempts reached. Stopping auto-reconnect.',
      );
      return;
    }

    // Exponential backoff: 1s, 2s, 4s, 8s, 16s, 30s (max)
    final delay = Duration(
      seconds: (_initialReconnectDelay.inSeconds * (1 << _reconnectAttempts))
          .clamp(1, 30),
    );

    _reconnectAttempts++;
    AppLogger.i(
      'Scheduling WebSocket reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts in ${delay.inSeconds}s',
    );

    _reconnectTimer = Timer(delay, () {
      if (!_isConnected) {
        AppLogger.i('Attempting WebSocket reconnection...');
        connect().catchError((error) {
          AppLogger.e('Reconnection attempt failed: $error', error);
        });
      }
    });
  }

  /// Disconnect from WebSocket server
  Future<void> disconnect() async {
    if (_channel != null) {
      AppLogger.i('Disconnecting WebSocket');
      await _subscription?.cancel();
      await _channel?.sink.close(status.goingAway);
      _channel = null;
      _subscription = null;
      _isConnected = false;
      _connectionController.add(false);
      AppLogger.i('WebSocket disconnected');
    }
  }

  /// Reconnect to WebSocket server (manual)
  Future<void> reconnect() async {
    _reconnectAttempts = 0; // Reset attempts for manual reconnect
    _reconnectTimer?.cancel();
    await disconnect();
    await Future.delayed(const Duration(seconds: 1));
    await connect();
  }

  /// Dispose resources
  void dispose() {
    _reconnectTimer?.cancel();
    disconnect();
    _connectionController.close();
    _messageController.close();
  }
}
