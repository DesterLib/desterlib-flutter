import '../api_client.dart';
import '../models/api_response.dart';
import '../models/media_models.dart';

/// Movies API endpoints
class MoviesApi {
  final ApiClient _client;

  MoviesApi(this._client);

  /// Get all movies
  Future<List<MovieDto>> getMovies() async {
    final response = await _client.get<Map<String, dynamic>>('/api/v1/movies');

    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data!,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get movies');
    }

    return apiResponse.data!
        .map((json) => MovieDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get movie by ID
  Future<MovieDto> getMovieById(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/movies/$id',
    );

    final apiResponse = ApiResponse<MovieDto>.fromJson(
      response.data!,
      (json) => MovieDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get movie');
    }

    return apiResponse.data!;
  }
}
