// Features
import 'package:dester/features/settings/domain/entities/library.dart';
import 'package:dester/features/settings/domain/repository/library_repository.dart';

import 'get_libraries.dart';


/// Implementation of GetLibraries use case
class GetLibrariesImpl implements GetLibraries {
  final LibraryRepository repository;

  GetLibrariesImpl(this.repository);

  @override
  Future<List<Library>> call({
    bool? isLibrary,
    LibraryType? libraryType,
  }) async {
    return await repository.getLibraries(
      isLibrary: isLibrary,
      libraryType: libraryType,
    );
  }
}
