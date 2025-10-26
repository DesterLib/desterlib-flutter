import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ScanApi
void main() {
  final instance = Openapi().getScanApi();

  group(ScanApi, () {
    // Scan a local file path and fetch TMDB metadata
    //
    // Scans a local directory path and returns discovered media files with TMDB metadata. - Automatically fetches metadata from TMDB using the API key from environment variables - Extracts IDs from filenames and folder names (supports {tmdb-XXX}, {imdb-ttXXX}, {tvdb-XXX} formats) - Stores media information in the database with proper relationships - Supports both movies and TV shows 
    //
    //Future<ApiV1ScanPathPost200Response> apiV1ScanPathPost(ApiV1ScanPathPostRequest apiV1ScanPathPostRequest) async
    test('test apiV1ScanPathPost', () async {
      // TODO
    });

  });
}
