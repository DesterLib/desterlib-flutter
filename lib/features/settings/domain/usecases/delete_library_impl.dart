// Features
import 'package:dester/features/settings/domain/repository/library_repository.dart';

import 'delete_library.dart';


/// Implementation of DeleteLibrary use case
class DeleteLibraryImpl implements DeleteLibrary {
  final LibraryRepository repository;

  DeleteLibraryImpl(this.repository);

  @override
  Future<void> call(String id) async {
    return await repository.deleteLibrary(id);
  }
}
