import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/providers.dart';
import 'package:dester/core/services/websocket_service.dart';

class LogsApiService {
  final LogsApi _logsApi;

  LogsApiService(this._logsApi);

  /// Fetch historical logs from the backend
  Future<List<LogMessage>> fetchLogs({int limit = 100, String? level}) async {
    try {
      final response = await _logsApi.apiV1LogsGet(limit: limit, level: level);

      final logsData = response.data?.data;
      if (logsData == null) return [];

      // Convert API response to LogMessage objects
      return logsData.map((logEntry) {
        return LogMessage(
          level: logEntry.level ?? 'info',
          message: logEntry.message ?? '',
          timestamp: logEntry.timestamp ?? '',
          meta: logEntry.meta?.value as Map<String, dynamic>?,
        );
      }).toList();
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  /// Clear all logs on the server
  Future<void> clearLogs() async {
    try {
      await _logsApi.apiV1LogsDelete();
    } catch (e) {
      throw Exception('Failed to clear logs: $e');
    }
  }
}

// Provider for logs API service
final logsApiServiceProvider = Provider<LogsApiService>((ref) {
  final client = ref.watch(openapiClientProvider);
  return LogsApiService(client.getLogsApi());
});
