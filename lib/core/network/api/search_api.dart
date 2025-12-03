import '../api_client.dart';
import '../models/api_response.dart';
import '../models/media_models.dart';

/// Search API endpoints
class SearchApi {
  final ApiClient _client;

  SearchApi(this._client);

  /// Search for media by query
  Future<SearchResultsDto> search(String query) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/search',
      queryParameters: {'query': query},
    );

    final apiResponse = ApiResponse<SearchResultsDto>.fromJson(
      response.data!,
      (json) => SearchResultsDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to search');
    }

    return apiResponse.data!;
  }
}
