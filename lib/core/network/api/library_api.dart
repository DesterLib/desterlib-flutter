import '../api_client.dart';
import '../models/api_response.dart';
import '../models/library_models.dart';

/// Library API endpoints
class LibraryApi {
  final ApiClient _client;

  LibraryApi(this._client);

  /// Get all libraries
  Future<List<LibraryDto>> getLibraries({bool? includeMedia}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/library',
      queryParameters: {if (includeMedia != null) 'includeMedia': includeMedia},
    );

    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data!,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to get libraries');
    }

    return apiResponse.data!
        .map((json) => LibraryDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Update library
  Future<LibraryDto> updateLibrary(
    String id,
    UpdateLibraryRequestDto request,
  ) async {
    final response = await _client.put<Map<String, dynamic>>(
      '/api/v1/library/$id',
      data: request.toJson(),
    );

    final apiResponse = ApiResponse<LibraryDto>.fromJson(
      response.data!,
      (json) => LibraryDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.error ?? 'Failed to update library');
    }

    return apiResponse.data!;
  }

  /// Delete library
  Future<void> deleteLibrary(String id, DeleteLibraryRequestDto request) async {
    await _client.delete<Map<String, dynamic>>(
      '/api/v1/library/$id',
      data: request.toJson(),
    );
  }
}
