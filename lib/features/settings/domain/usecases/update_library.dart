// Features
import 'package:dester/features/settings/domain/entities/library.dart';


/// Use case interface for updating a library
abstract class UpdateLibrary {
  Future<Library> call({
    required String id,
    String? name,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    String? libraryPath,
    LibraryType? libraryType,
  });
}
