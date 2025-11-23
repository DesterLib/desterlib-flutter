// Features
import 'package:dester/features/settings/domain/entities/library.dart';


/// Use case interface for getting libraries
abstract class GetLibraries {
  Future<List<Library>> call({bool? isLibrary, LibraryType? libraryType});
}
