import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for LibraryApi
void main() {
  final instance = Openapi().getLibraryApi();

  group(LibraryApi, () {
    // Delete a library and its associated media
    //
    // Deletes a library: - Removes the library structure and metadata from the database - Deletes all media entries that ONLY belong to this library - Keeps media that also belongs to other libraries - Does NOT delete actual files on disk (prevents accidental data loss) - Cascade deletes related data (genres, persons, external IDs, etc.) 
    //
    //Future<ApiV1LibraryDelete200Response> apiV1LibraryDelete(ApiV1LibraryDeleteRequest apiV1LibraryDeleteRequest) async
    test('test apiV1LibraryDelete', () async {
      // TODO
    });

    // Get all libraries with optional filtering
    //
    // Retrieves a list of libraries with optional filtering by: - isLibrary: Filter by actual libraries vs collections - libraryType: Filter by media type (MOVIE, TV_SHOW, MUSIC, COMIC) 
    //
    //Future<ApiV1LibraryGet200Response> apiV1LibraryGet({ bool isLibrary, String libraryType }) async
    test('test apiV1LibraryGet', () async {
      // TODO
    });

    // Update library details
    //
    // Updates library metadata including name, description, URLs, and settings. Empty string values for optional fields will be set to null. 
    //
    //Future<ApiV1LibraryPut200Response> apiV1LibraryPut(ApiV1LibraryPutRequest apiV1LibraryPutRequest) async
    test('test apiV1LibraryPut', () async {
      // TODO
    });

  });
}
