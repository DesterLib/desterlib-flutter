import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/websocket_service.dart';
import 'websocket_provider.dart';
import '../../features/logs/data/logs_api_service.dart';

/// Maximum number of logs to keep in memory
const int maxLogsInMemory = 100;

/// Logs state model
class LogsState {
  final List<LogMessage> logs;
  final bool isConnected;
  final String? levelFilter;
  final bool isLoadingHistorical;

  const LogsState({
    this.logs = const [],
    this.isConnected = false,
    this.levelFilter,
    this.isLoadingHistorical = false,
  });

  LogsState copyWith({
    List<LogMessage>? logs,
    bool? isConnected,
    String? levelFilter,
    bool? isLoadingHistorical,
    bool clearLevelFilter = false,
  }) {
    return LogsState(
      logs: logs ?? this.logs,
      isConnected: isConnected ?? this.isConnected,
      levelFilter: clearLevelFilter ? null : (levelFilter ?? this.levelFilter),
      isLoadingHistorical: isLoadingHistorical ?? this.isLoadingHistorical,
    );
  }

  /// Get filtered logs based on level filter
  List<LogMessage> get filteredLogs {
    if (levelFilter == null || levelFilter!.isEmpty) {
      return logs;
    }
    return logs.where((log) => log.level == levelFilter).toList();
  }
}

/// Logs notifier
class LogsNotifier extends Notifier<LogsState> {
  bool _hasLoadedHistorical = false;

  @override
  LogsState build() {
    final service = ref.watch(websocketServiceProvider);

    // Listen to log messages from WebSocket
    service.logMessageStream.listen((message) {
      _addLog(message);
    });

    // Listen to connection state
    service.connectionStateStream.listen((isConnected) {
      state = state.copyWith(isConnected: isConnected);
    });

    // Load historical logs after build completes (avoid circular dependency)
    Future.microtask(() => _loadHistoricalLogs());

    // Get initial connection state
    return LogsState(isConnected: service.isConnected);
  }

  /// Load historical logs from backend
  Future<void> _loadHistoricalLogs() async {
    if (_hasLoadedHistorical) return;
    _hasLoadedHistorical = true;

    state = state.copyWith(isLoadingHistorical: true);

    try {
      final logsService = ref.read(logsApiServiceProvider);
      final historicalLogs = await logsService.fetchLogs(limit: 100);

      // Add historical logs to state (oldest first, so new WebSocket logs append)
      state = state.copyWith(logs: historicalLogs, isLoadingHistorical: false);
    } catch (e) {
      // Silently fail - not critical if historical logs can't be loaded
      state = state.copyWith(isLoadingHistorical: false);
    }
  }

  /// Add a new log message (insert at beginning for newest-first order)
  void _addLog(LogMessage log) {
    final newLogs = List<LogMessage>.from(state.logs)..insert(0, log);

    // Keep only the most recent logs (limit memory usage)
    if (newLogs.length > maxLogsInMemory) {
      // Remove oldest logs from the end
      newLogs.removeRange(maxLogsInMemory, newLogs.length);
    }

    state = state.copyWith(logs: newLogs);
  }

  /// Clear all logs (local only)
  void clearLogs() {
    state = state.copyWith(logs: []);
  }

  /// Clear all logs including server logs
  Future<void> clearAllLogs() async {
    try {
      final logsService = ref.read(logsApiServiceProvider);
      await logsService.clearLogs();
      state = state.copyWith(logs: []);
    } catch (e) {
      // If server clear fails, still clear local logs
      state = state.copyWith(logs: []);
      rethrow;
    }
  }

  /// Refresh logs from server
  Future<void> refreshLogs() async {
    _hasLoadedHistorical = false;
    await _loadHistoricalLogs();
  }

  /// Set level filter
  void setLevelFilter(String? level) {
    if (level == null || level.isEmpty) {
      state = state.copyWith(clearLevelFilter: true);
    } else {
      state = state.copyWith(levelFilter: level);
    }
  }
}

/// Logs provider
final logsProvider = NotifierProvider<LogsNotifier, LogsState>(() {
  return LogsNotifier();
});
