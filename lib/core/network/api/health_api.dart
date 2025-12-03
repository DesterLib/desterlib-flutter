import '../api_client.dart';

/// Health check API endpoint
class HealthApi {
  final ApiClient _client;

  HealthApi(this._client);

  /// Check API health
  Future<Map<String, dynamic>> check() async {
    final response = await _client.get<Map<String, dynamic>>('/health');
    return response.data ?? {};
  }
}
