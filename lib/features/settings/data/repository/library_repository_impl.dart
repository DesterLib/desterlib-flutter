// Features
import 'package:dester/features/settings/data/datasources/library_datasource.dart';
import 'package:dester/features/settings/data/mappers/library_mapper.dart';
import 'package:dester/features/settings/domain/entities/library.dart';
import 'package:dester/features/settings/domain/repository/library_repository.dart';


/// Implementation of LibraryRepository
class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryDataSource dataSource;

  LibraryRepositoryImpl({required this.dataSource});

  @override
  Future<List<Library>> getLibraries({
    bool? isLibrary,
    LibraryType? libraryType,
  }) async {
    final models = await dataSource.getLibraries(
      isLibrary: isLibrary,
      libraryType: libraryType,
    );
    return models.map((model) => LibraryMapper.fromApiModel(model)).toList();
  }

  @override
  Future<Library> updateLibrary({
    required String id,
    String? name,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    String? libraryPath,
    LibraryType? libraryType,
  }) async {
    final model = await dataSource.updateLibrary(
      id: id,
      name: name,
      description: description,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      libraryPath: libraryPath,
      libraryType: libraryType,
    );
    return LibraryMapper.fromApiModel(model);
  }

  @override
  Future<void> deleteLibrary(String id) async {
    await dataSource.deleteLibrary(id);
  }

  @override
  Future<String> scanLibrary({
    required String path,
    String? libraryName,
    String? mediaType,
  }) async {
    return await dataSource.scanLibrary(
      path: path,
      libraryName: libraryName,
      mediaType: mediaType,
    );
  }
}
