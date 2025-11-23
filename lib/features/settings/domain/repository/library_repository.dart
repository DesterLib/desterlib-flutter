// Features
import 'package:dester/features/settings/domain/entities/library.dart';


/// Repository interface for library operations
abstract class LibraryRepository {
  /// Get all libraries
  Future<List<Library>> getLibraries({
    bool? isLibrary,
    LibraryType? libraryType,
  });

  /// Update a library
  Future<Library> updateLibrary({
    required String id,
    String? name,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    String? libraryPath,
    LibraryType? libraryType,
  });

  /// Delete a library
  Future<void> deleteLibrary(String id);

  /// Scan a path to create a library
  Future<String> scanLibrary({
    required String path,
    String? libraryName,
    String? mediaType,
  });
}
