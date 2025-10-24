import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/core/services/api_client.dart';
import 'package:dester/core/config/api_config.dart';
import 'package:dester/features/library/data/models/library_model.dart';

class LibraryApiService {
  final ApiClient _apiClient;

  LibraryApiService(this._apiClient);

  static const String _basePath = '/api/v1/library';

  /// Get all libraries with optional filtering
  Future<List<LibraryModel>> getLibraries({LibraryFilters? filters}) async {
    final queryParams = filters?.toQueryParams() ?? {};
    final url = _buildUrl(_basePath, queryParams);

    try {
      final response = await _apiClient.get(url);

      // The API client returns Map<String, dynamic>
      if (response.containsKey('data')) {
        final data = response['data'];

        if (data is List) {
          final List<dynamic> jsonList = data;

          return jsonList.map<LibraryModel>((json) {
            // Ensure json is cast to Map<String, dynamic> before calling fromJson
            if (json is Map<String, dynamic>) {
              return LibraryModel.fromJson(json);
            } else {
              throw TypeError();
            }
          }).toList();
        } else if (data == null) {
          // Return empty list if data is null
          return [];
        } else {
          throw Exception(
            'Expected list in data field, got: ${data.runtimeType}',
          );
        }
      } else {
        throw Exception('No data field in response. Response: $response');
      }
    } catch (e) {
      throw Exception('Failed to fetch libraries: $e');
    }
  }

  /// Update library details
  Future<LibraryModel> updateLibrary(LibraryUpdateRequest request) async {
    final url = _buildUrl(_basePath);

    final response = await _apiClient.put(url, request.toJson());

    if (response.containsKey('library')) {
      return LibraryModel.fromJson(response['library']);
    } else {
      throw Exception('Expected library object in response');
    }
  }

  /// Delete library and its associated media
  Future<Map<String, dynamic>> deleteLibrary(
    LibraryDeleteRequest request,
  ) async {
    final url = _buildUrl(_basePath);

    return await _apiClient.put(url, request.toJson());
  }

  String _buildUrl(String path, [Map<String, dynamic>? queryParams]) {
    final baseUrl = ApiConfig.baseUrl;
    final uri = Uri.parse('$baseUrl$path');

    if (queryParams != null && queryParams.isNotEmpty) {
      return uri
          .replace(
            queryParameters: queryParams.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          )
          .toString();
    }

    return uri.toString();
  }
}

// Provider for library API service
final libraryApiServiceProvider = Provider<LibraryApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LibraryApiService(apiClient);
});
