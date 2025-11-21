import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ScanApi
void main() {
  final instance = Openapi().getScanApi();

  group(ScanApi, () {
    // Cleanup stale scan jobs
    //
    // Manually trigger cleanup of scan jobs that have been stuck in IN_PROGRESS state. Useful after API crashes or unexpected shutdowns. 
    //
    //Future<ApiV1ScanCleanupPost200Response> apiV1ScanCleanupPost() async
    test('test apiV1ScanCleanupPost', () async {
      // TODO
    });

    // Get scan job status
    //
    // Get detailed status information about a scan job
    //
    //Future apiV1ScanJobScanJobIdGet(String scanJobId) async
    test('test apiV1ScanJobScanJobIdGet', () async {
      // TODO
    });

    // Scan a local file path and fetch TMDB metadata
    //
    // Scans a local directory path and returns discovered media files with TMDB metadata. - Automatically fetches metadata from TMDB using the API key from environment variables - Extracts IDs from filenames and folder names (supports {tmdb-XXX}, {imdb-ttXXX}, {tvdb-XXX} formats) - Stores media information in the database with proper relationships - Supports both movies and TV shows 
    //
    //Future<ApiV1ScanPathPost200Response> apiV1ScanPathPost(ApiV1ScanPathPostRequest apiV1ScanPathPostRequest) async
    test('test apiV1ScanPathPost', () async {
      // TODO
    });

    // Resume a failed or paused scan job
    //
    // Resumes a scan job that was previously paused or failed. - Continues processing from where it left off - Only processes remaining unscanned folders - Sends progress updates via WebSocket 
    //
    //Future<ApiV1ScanResumeScanJobIdPost202Response> apiV1ScanResumeScanJobIdPost(String scanJobId) async
    test('test apiV1ScanResumeScanJobIdPost', () async {
      // TODO
    });

  });
}
