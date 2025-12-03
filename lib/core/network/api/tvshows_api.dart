import '../api_client.dart';
import '../models/api_response.dart';
import '../models/media_models.dart';

/// TV Shows API endpoints
class TvShowsApi {
  final ApiClient _client;

  TvShowsApi(this._client);

  /// Get all TV shows
  Future<List<TvShowDto>> getTvShows() async {
    final response = await _client.get<Map<String, dynamic>>('/api/v1/tvshows');

    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data!,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get TV shows');
    }

    return apiResponse.data!
        .map((json) => TvShowDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get TV show by ID
  Future<TvShowDto> getTvShowById(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/tvshows/$id',
    );

    final apiResponse = ApiResponse<TvShowDto>.fromJson(
      response.data!,
      (json) => TvShowDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get TV show');
    }

    return apiResponse.data!;
  }
}
