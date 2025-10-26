import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for ApiV1ScanPathPost200ResponseCacheStats
void main() {
  final instance = ApiV1ScanPathPost200ResponseCacheStatsBuilder();
  // TODO add properties to the builder and call build()

  group(ApiV1ScanPathPost200ResponseCacheStats, () {
    // Number of items that reused existing metadata from database
    // num metadataFromCache
    test('to test the property `metadataFromCache`', () async {
      // TODO
    });

    // Number of items that fetched fresh metadata from TMDB
    // num metadataFromTMDB
    test('to test the property `metadataFromTMDB`', () async {
      // TODO
    });

    // Total number of items with metadata
    // num totalMetadataFetched
    test('to test the property `totalMetadataFetched`', () async {
      // TODO
    });

  });
}
