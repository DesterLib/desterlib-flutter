// External packages
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

// Core
import 'package:dester/core/network/api_client_service.dart';
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';

/// Data source for library operations
class LibraryDataSource {
  /// Get all libraries from the API
  Future<List<ModelLibrary>> getLibraries({
    bool? isLibrary,
    LibraryType? libraryType,
  }) async {
    try {
      final client = ApiClientService.getClient();
      final libraryApi = client.getLibraryApi();

      final apiLibraryType = libraryType != null
          ? _mapLibraryTypeToApi(libraryType)
          : null;

      final response = await libraryApi.apiV1LibraryGet(
        isLibrary: isLibrary,
        libraryType: apiLibraryType,
      );

      if (response.data?.success == true && response.data?.data != null) {
        return response.data!.data!.toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception('Failed to fetch libraries: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch libraries: $e');
    }
  }

  /// Update a library
  Future<ModelLibrary> updateLibrary({
    required String id,
    String? name,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    String? libraryPath,
    LibraryType? libraryType,
  }) async {
    try {
      final client = ApiClientService.getClient();
      final libraryApi = client.getLibraryApi();

      final apiLibraryType = libraryType != null
          ? _mapLibraryTypeToApiEnum(libraryType)
          : null;

      final request = ApiV1LibraryPutRequest(
        (b) => b
          ..id = id
          ..name = name
          ..description = description
          ..posterUrl = posterUrl
          ..backdropUrl = backdropUrl
          ..libraryPath = libraryPath
          ..libraryType = apiLibraryType,
      );

      final response = await libraryApi.apiV1LibraryPut(
        apiV1LibraryPutRequest: request,
      );

      if (response.data?.success == true &&
          response.data?.data?.library_ != null) {
        return response.data!.data!.library_!;
      }

      throw Exception('Failed to update library: Invalid response');
    } on DioException catch (e) {
      throw Exception('Failed to update library: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update library: $e');
    }
  }

  /// Delete a library
  Future<void> deleteLibrary(String id) async {
    try {
      final client = ApiClientService.getClient();
      final libraryApi = client.getLibraryApi();

      final request = ApiV1LibraryDeleteRequest((b) => b..id = id);

      await libraryApi.apiV1LibraryDelete(apiV1LibraryDeleteRequest: request);
    } on DioException catch (e) {
      throw Exception('Failed to delete library: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete library: $e');
    }
  }

  /// Map domain LibraryType to API string
  String? _mapLibraryTypeToApi(LibraryType type) {
    switch (type) {
      case LibraryType.movie:
        return 'MOVIE';
      case LibraryType.tvShow:
        return 'TV_SHOW';
      case LibraryType.music:
        return 'MUSIC';
      case LibraryType.comic:
        return 'COMIC';
    }
  }

  /// Scan a path to create a library
  Future<String> scanLibrary({
    required String path,
    String? libraryName,
    String? mediaType,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      AppLogger.d(
        'Starting library scan: path=$path, name=$libraryName, type=$mediaType',
      );

      final client = ApiClientService.getClient();
      final scanApi = client.getScanApi();

      final options = ApiV1ScanPathPostRequestOptions(
        (b) => b
          ..mediaType = mediaType != null
              ? (mediaType == 'movie'
                    ? ApiV1ScanPathPostRequestOptionsMediaTypeEnum.movie
                    : ApiV1ScanPathPostRequestOptionsMediaTypeEnum.tv)
              : null,
      );

      final request = ApiV1ScanPathPostRequest(
        (b) => b
          ..path = path
          ..options = options.toBuilder(),
      );

      // Scan operations return 202 immediately, so we only wait for the acknowledgment
      final response = await scanApi.apiV1ScanPathPost(
        apiV1ScanPathPostRequest: request,
      );

      stopwatch.stop();
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000;

      if (durationSeconds > 3) {
        AppLogger.w(
          'Library scan request took ${durationSeconds.toStringAsFixed(2)}s (exceeds 3s threshold): path=$path, name=$libraryName',
        );
      } else {
        AppLogger.d(
          'Library scan request completed in ${durationSeconds.toStringAsFixed(2)}s',
        );
      }

      if (response.data?.success == true) {
        // The scan is a continuous background process that returns 202 Accepted
        // The response contains path, mediaType, queued, and queuePosition
        // The library will be created during the scanning process
        AppLogger.i(
          'Scan started successfully. Library will be created during the scan process.',
        );
        // Return a placeholder - the actual library will appear once scanning begins
        return 'scan-in-progress';
      }

      AppLogger.e('Failed to start library scan: Invalid response');
      throw Exception('Failed to start library scan: Invalid response');
    } on DioException catch (e) {
      stopwatch.stop();
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000;
      if (durationSeconds > 3) {
        AppLogger.w(
          'Library scan request failed after ${durationSeconds.toStringAsFixed(2)}s (exceeds 3s threshold): ${e.message}',
        );
      }
      AppLogger.e('Failed to scan library: ${e.message}', e);
      throw Exception('Failed to scan library: ${e.message}');
    } catch (e, stackTrace) {
      stopwatch.stop();
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000;
      if (durationSeconds > 3) {
        AppLogger.w(
          'Library scan request failed after ${durationSeconds.toStringAsFixed(2)}s (exceeds 3s threshold): $e',
        );
      }
      AppLogger.e('Failed to scan library: $e', e, stackTrace);
      throw Exception('Failed to scan library: $e');
    }
  }

  /// Map domain LibraryType to API enum
  ApiV1LibraryPutRequestLibraryTypeEnum? _mapLibraryTypeToApiEnum(
    LibraryType type,
  ) {
    switch (type) {
      case LibraryType.movie:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MOVIE;
      case LibraryType.tvShow:
        return ApiV1LibraryPutRequestLibraryTypeEnum.TV_SHOW;
      case LibraryType.music:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MUSIC;
      case LibraryType.comic:
        return ApiV1LibraryPutRequestLibraryTypeEnum.COMIC;
    }
  }
}
