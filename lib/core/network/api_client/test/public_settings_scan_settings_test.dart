import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for PublicSettingsScanSettings
void main() {
  final instance = PublicSettingsScanSettingsBuilder();
  // TODO add properties to the builder and call build()

  group(PublicSettingsScanSettings, () {
    // Type of media to scan (movie or tv)
    // String mediaType
    test('to test the property `mediaType`', () async {
      // TODO
    });

    // Maximum directory depth to scan
    // num maxDepth
    test('to test the property `maxDepth`', () async {
      // TODO
    });

    // PublicSettingsScanSettingsMediaTypeDepth mediaTypeDepth
    test('to test the property `mediaTypeDepth`', () async {
      // TODO
    });

    // File extensions to include in the scan
    // BuiltList<String> fileExtensions
    test('to test the property `fileExtensions`', () async {
      // TODO
    });

    // Regex pattern to match filenames
    // String filenamePattern
    test('to test the property `filenamePattern`', () async {
      // TODO
    });

    // Regex pattern to exclude files/directories
    // String excludePattern
    test('to test the property `excludePattern`', () async {
      // TODO
    });

    // Regex pattern to include files/directories
    // String includePattern
    test('to test the property `includePattern`', () async {
      // TODO
    });

    // Regex pattern to match directory names
    // String directoryPattern
    test('to test the property `directoryPattern`', () async {
      // TODO
    });

    // List of directory names to exclude
    // BuiltList<String> excludeDirectories
    test('to test the property `excludeDirectories`', () async {
      // TODO
    });

    // List of directory names to include
    // BuiltList<String> includeDirectories
    test('to test the property `includeDirectories`', () async {
      // TODO
    });

    // Re-fetch metadata even if it already exists
    // bool rescan
    test('to test the property `rescan`', () async {
      // TODO
    });

    // Enable batch scanning mode for large libraries
    // bool batchScan
    test('to test the property `batchScan`', () async {
      // TODO
    });

    // Minimum file size in bytes
    // num minFileSize
    test('to test the property `minFileSize`', () async {
      // TODO
    });

    // Maximum file size in bytes
    // num maxFileSize
    test('to test the property `maxFileSize`', () async {
      // TODO
    });

    // Whether to follow symbolic links during scanning
    // bool followSymlinks
    test('to test the property `followSymlinks`', () async {
      // TODO
    });

  });
}
