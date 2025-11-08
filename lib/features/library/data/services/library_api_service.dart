import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/providers.dart';

class LibraryApiService {
  final LibraryApi _libraryApi;

  LibraryApiService(this._libraryApi);

  /// Get all libraries with optional filtering
  Future<BuiltList<ModelLibrary>> getLibraries({
    bool? isLibrary,
    ModelLibraryLibraryTypeEnum? libraryType,
  }) async {
    try {
      final response = await _libraryApi.apiV1LibraryGet(
        isLibrary: isLibrary,
        libraryType: libraryType?.name,
      );

      // The API returns ApiV1LibraryGet200Response with success and data fields
      final libraries = response.data?.data;
      if (libraries == null) return BuiltList<ModelLibrary>();

      return libraries;
    } catch (e) {
      throw Exception('Failed to fetch libraries: $e');
    }
  }

  /// Update library details
  Future<ModelLibrary> updateLibrary(ApiV1LibraryPutRequest request) async {
    try {
      final response = await _libraryApi.apiV1LibraryPut(
        apiV1LibraryPutRequest: request,
      );

      final library = response.data?.data?.library_;
      if (library == null) {
        throw Exception('No library in response');
      }

      return library;
    } catch (e) {
      throw Exception('Failed to update library: $e');
    }
  }

  /// Delete library and its associated media
  Future<ApiV1LibraryDelete200Response> deleteLibrary(
    ApiV1LibraryDeleteRequest request,
  ) async {
    try {
      final response = await _libraryApi.apiV1LibraryDelete(
        apiV1LibraryDeleteRequest: request,
      );

      if (response.data == null) {
        throw Exception('No response data');
      }

      return response.data!;
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
