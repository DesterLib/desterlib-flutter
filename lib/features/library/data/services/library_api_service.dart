import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/providers.dart';
import 'package:dester/features/library/data/models/library_model.dart';

class LibraryApiService {
  final LibraryApi _libraryApi;

  LibraryApiService(this._libraryApi);

  /// Get all libraries with optional filtering
  Future<List<LibraryModel>> getLibraries({LibraryFilters? filters}) async {
    try {
      final response = await _libraryApi.apiV1LibraryGet(
        isLibrary: filters?.isLibrary,
        libraryType: filters?.libraryType?.name,
      );

      final libraries = response.data;
      if (libraries == null) return [];

      return libraries.map((lib) {
        return LibraryModel.fromJson({
          'id': lib.id,
          'name': lib.name,
          'slug': lib.slug,
          'description': lib.description,
          'posterUrl': lib.posterUrl,
          'backdropUrl': lib.backdropUrl,
          'isLibrary': lib.isLibrary,
          'libraryPath': lib.libraryPath,
          'libraryType': lib.libraryType?.name,
          'createdAt': lib.createdAt.toIso8601String(),
          'updatedAt': lib.updatedAt.toIso8601String(),
          'parentId': lib.parentId,
          'mediaCount': lib.mediaCount,
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch libraries: $e');
    }
  }

  /// Update library details
  Future<LibraryModel> updateLibrary(LibraryUpdateRequest request) async {
    try {
      final putRequest = ApiV1LibraryPutRequestBuilder()
        ..id = request.id
        ..name = request.name
        ..description = request.description;

      final response = await _libraryApi.apiV1LibraryPut(
        apiV1LibraryPutRequest: putRequest.build(),
      );

      final library = response.data?.library_;
      if (library == null) {
        throw Exception('No library in response');
      }

      return LibraryModel.fromJson({
        'id': library.id,
        'name': library.name,
        'slug': library.slug,
        'description': library.description,
        'posterUrl': library.posterUrl,
        'backdropUrl': library.backdropUrl,
        'isLibrary': library.isLibrary,
        'libraryPath': library.libraryPath,
        'libraryType': library.libraryType?.name,
        'createdAt': library.createdAt.toIso8601String(),
        'updatedAt': library.updatedAt.toIso8601String(),
        'parentId': library.parentId,
        'mediaCount': library.mediaCount,
      });
    } catch (e) {
      throw Exception('Failed to update library: $e');
    }
  }

  /// Delete library and its associated media
  Future<Map<String, dynamic>> deleteLibrary(
    LibraryDeleteRequest request,
  ) async {
    try {
      final deleteRequest = ApiV1LibraryDeleteRequestBuilder()..id = request.id;

      final response = await _libraryApi.apiV1LibraryDelete(
        apiV1LibraryDeleteRequest: deleteRequest.build(),
      );

      return {
        'success': response.data?.success ?? false,
        'message': response.data?.message ?? '',
        'mediaDeleted': response.data?.mediaDeleted ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to delete library: $e');
    }
  }
}

// Provider for library API service
final libraryApiServiceProvider = Provider<LibraryApiService>((ref) {
  final client = ref.watch(openapiClientProvider);
  return LibraryApiService(client.getLibraryApi());
});
