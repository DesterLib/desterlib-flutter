import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for ApiV1ScanPathPostRequestOptions
void main() {
  final instance = ApiV1ScanPathPostRequestOptionsBuilder();
  // TODO add properties to the builder and call build()

  group(ApiV1ScanPathPostRequestOptions, () {
    // Maximum directory depth to scan (0-10)
    // num maxDepth
    test('to test the property `maxDepth`', () async {
      // TODO
    });

    // Media type for TMDB API calls (movie or tv). Required for proper metadata fetching.
    // String mediaType
    test('to test the property `mediaType`', () async {
      // TODO
    });

    // File extensions to include in the scan
    // BuiltList<String> fileExtensions (default value: ListBuilder())
    test('to test the property `fileExtensions`', () async {
      // TODO
    });

    // Name for the library. If not provided, uses \"Library - {path}\"
    // String libraryName
    test('to test the property `libraryName`', () async {
      // TODO
    });

    // If true, re-fetches metadata from TMDB even if it already exists in the database. If false or omitted, skips items that already have metadata.
    // bool rescan (default value: false)
    test('to test the property `rescan`', () async {
      // TODO
    });

  });
}
