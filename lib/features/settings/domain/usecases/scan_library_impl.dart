// Features
import 'package:dester/features/settings/domain/repository/library_repository.dart';

import 'scan_library.dart';


/// Implementation of ScanLibrary use case
class ScanLibraryImpl implements ScanLibrary {
  final LibraryRepository repository;

  ScanLibraryImpl(this.repository);

  @override
  Future<String> call({
    required String path,
    String? libraryName,
    String? mediaType,
  }) async {
    return await repository.scanLibrary(
      path: path,
      libraryName: libraryName,
      mediaType: mediaType,
    );
  }
}
