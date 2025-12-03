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
    final result = await dataSource.getLibraries(
      isLibrary: isLibrary,
      libraryType: libraryType,
    );

    return result.fold(
      onSuccess: (models) =>
          models.map((model) => LibraryMapper.fromApiModel(model)).toList(),
      onFailure: (failure) => throw Exception(failure.message),
    );
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
    // API only supports name and path updates
    final result = await dataSource.updateLibrary(id, name ?? '', libraryPath);

    return result.fold(
      onSuccess: (model) => LibraryMapper.fromApiModel(model),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  @override
  Future<void> deleteLibrary(String id) async {
    final result = await dataSource.deleteLibrary(id, false);
    return result.fold(
      onSuccess: (_) => null,
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  @override
  Future<String> scanLibrary({
    required String path,
    String? libraryName,
    String? mediaType,
  }) async {
    final result = await dataSource.scanLibrary(
      path: path,
      name: libraryName,
      mediaType: mediaType ?? 'movie',
    );

    return result.fold(
      onSuccess: (response) => response.jobId,
      onFailure: (failure) => throw Exception(failure.message),
    );
  }
}
