import '../api_client.dart';
import '../models/api_response.dart';
import '../models/scan_models.dart';

/// Scan API endpoints
class ScanApi {
  final ApiClient _client;

  ScanApi(this._client);

  /// Scan a path
  Future<ScanResponseDto> scanPath(ScanPathRequestDto request) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/scan/path',
      data: request.toJson(),
    );

    final apiResponse = ApiResponse<ScanResponseDto>.fromJson(
      response.data!,
      (json) => ScanResponseDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to start scan');
    }

    return apiResponse.data!;
  }

  /// Get scan job status
  Future<ScanJobDto> getJobStatus(String jobId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/scan/job/$jobId',
    );

    final apiResponse = ApiResponse<ScanJobDto>.fromJson(
      response.data!,
      (json) => ScanJobDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get job status');
    }

    return apiResponse.data!;
  }

  /// Get all scan jobs
  Future<List<ScanJobDto>> getAllJobs({
    String? status,
    String? libraryId,
    int? limit,
    int? offset,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/scan/jobs',
      queryParameters: {
        if (status != null) 'status': status,
        if (libraryId != null) 'libraryId': libraryId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data!,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get jobs');
    }

    final jobs = apiResponse.data!['jobs'] as List<dynamic>;
    return jobs
        .map((json) => ScanJobDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Pause a scan job
  Future<void> pauseJob(String jobId) async {
    await _client.post<Map<String, dynamic>>('/api/v1/scan/pause/$jobId');
  }

  /// Resume a scan job
  Future<void> resumeJob(String jobId) async {
    await _client.post<Map<String, dynamic>>('/api/v1/scan/resume/$jobId');
  }

  /// Cleanup orphaned media entries
  Future<void> cleanup() async {
    await _client.post<Map<String, dynamic>>('/api/v1/scan/cleanup');
  }
}
