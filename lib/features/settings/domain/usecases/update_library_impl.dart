// Features
import 'package:dester/features/settings/domain/entities/library.dart';
import 'package:dester/features/settings/domain/repository/library_repository.dart';

import 'update_library.dart';


/// Implementation of UpdateLibrary use case
class UpdateLibraryImpl implements UpdateLibrary {
  final LibraryRepository repository;

  UpdateLibraryImpl(this.repository);

  @override
  Future<Library> call({
    required String id,
    String? name,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    String? libraryPath,
    LibraryType? libraryType,
  }) async {
    return await repository.updateLibrary(
      id: id,
      name: name,
      description: description,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      libraryPath: libraryPath,
      libraryType: libraryType,
    );
  }
}
