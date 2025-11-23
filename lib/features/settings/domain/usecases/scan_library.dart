/// Use case interface for scanning a path to create a library
/// Returns the library ID that will be created (scan happens asynchronously)
abstract class ScanLibrary {
  Future<String> call({
    required String path,
    String? libraryName,
    String? mediaType,
  });
}
