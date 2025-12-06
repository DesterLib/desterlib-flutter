// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/network/dester_api.dart';
import 'package:dester/core/network/models/library_models.dart';
import 'package:dester/core/network/models/scan_models.dart';
import 'package:dester/core/network/models/settings_models.dart';
import 'package:dester/core/network/api_exception.dart';
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/data/models/local_library_model.dart';
import 'package:dester/features/settings/domain/entities/library.dart';

/// Data source for library operations using the new clean API
class LibraryDataSource {
  final DesterApi _api;

  LibraryDataSource(this._api);

  /// Get all libraries from the API
  Future<Result<List<ModelLibrary>>> getLibraries({
    bool? isLibrary,
    LibraryType? libraryType,
    bool? includeMedia,
  }) async {
    try {
      final libraries = await _api.library.getLibraries(
        includeMedia: includeMedia,
      );

      // Convert DTOs to ModelLibrary
      var modelLibraries = libraries.map((dto) {
        // Parse library type enum
        ModelLibraryLibraryTypeEnum? typeEnum;
        if (dto.libraryType == 'MOVIE') {
          typeEnum = ModelLibraryLibraryTypeEnum.MOVIE;
        } else if (dto.libraryType == 'TV_SHOW') {
          typeEnum = ModelLibraryLibraryTypeEnum.TV_SHOW;
        }

        return ModelLibrary(
          id: dto.id,
          name: dto.name,
          libraryPath: dto.libraryPath,
          isLibrary: dto.isLibrary,
          libraryType: typeEnum,
          createdAt: dto.createdAt,
          updatedAt: dto.updatedAt,
        );
      }).toList();

      // Client-side filtering if needed
      if (isLibrary != null) {
        modelLibraries = modelLibraries
            .where((lib) => lib.isLibrary == isLibrary)
            .toList();
      }

      if (libraryType != null) {
        final typeString = libraryType == LibraryType.movie
            ? 'MOVIE'
            : 'TV_SHOW';
        modelLibraries = modelLibraries
            .where((lib) => lib.libraryType == typeString)
            .toList();
      }

      return Success(modelLibraries);
    } on ApiException catch (e) {
      AppLogger.e('Failed to fetch libraries: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch libraries: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to fetch libraries'));
    }
  }

  /// Update a library
  Future<Result<ModelLibrary>> updateLibrary(
    String id,
    String name,
    String? path,
  ) async {
    try {
      final request = UpdateLibraryRequestDto(name: name, path: path);
      final dto = await _api.library.updateLibrary(id, request);

      // Parse library type enum
      ModelLibraryLibraryTypeEnum? typeEnum;
      if (dto.libraryType == 'MOVIE') {
        typeEnum = ModelLibraryLibraryTypeEnum.MOVIE;
      } else if (dto.libraryType == 'TV_SHOW') {
        typeEnum = ModelLibraryLibraryTypeEnum.TV_SHOW;
      }

      final library = ModelLibrary(
        id: dto.id,
        name: dto.name,
        libraryPath: dto.libraryPath,
        isLibrary: dto.isLibrary,
        libraryType: typeEnum,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );

      return Success(library);
    } on ApiException catch (e) {
      AppLogger.e('Failed to update library: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to update library: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to update library'));
    }
  }

  /// Delete a library
  Future<Result<void>> deleteLibrary(String id, bool deleteMedia) async {
    try {
      final request = DeleteLibraryRequestDto(deleteMedia: deleteMedia);
      await _api.library.deleteLibrary(id, request);
      return const Success(null);
    } on ApiException catch (e) {
      AppLogger.e('Failed to delete library: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to delete library: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to delete library'));
    }
  }

  /// Scan a library path
  Future<Result<ScanResponseDto>> scanLibrary({
    required String path,
    String? name,
    String? description,
    required String mediaType,
    int? movieDepth,
    int? tvDepth,
    bool? rescan,
    bool? followSymlinks,
    bool? refetchMetadata,
  }) async {
    try {
      final request = ScanPathRequestDto(
        path: path,
        name: name,
        description: description,
        options: ScanOptionsDto(
          mediaType: mediaType,
          mediaTypeDepth: (movieDepth != null || tvDepth != null)
              ? _createMediaTypeDepthDto(movieDepth, tvDepth)
              : null,
          rescan: rescan,
          followSymlinks: followSymlinks,
          refetchMetadata: refetchMetadata,
        ),
      );

      final response = await _api.scan.scanPath(request);
      return Success(response);
    } on ApiException catch (e) {
      AppLogger.e('Failed to scan library: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to scan library: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to scan library'));
    }
  }

  /// Helper to create MediaTypeDepthDto
  MediaTypeDepthDto _createMediaTypeDepthDto(int? movie, int? tv) {
    return MediaTypeDepthDto(movie: movie, tv: tv);
  }
}
