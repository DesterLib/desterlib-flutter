// External packages
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/network/api_client_service.dart';
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/domain/entities/scan_settings.dart';

/// Data source for settings operations
class SettingsDataSource {
  /// Get current settings from the API
  Future<Result<PublicSettings>> getSettings() async {
    try {
      final client = ApiClientService.getClient();
      final settingsApi = client.getSettingsApi();

      final response = await settingsApi.apiV1SettingsGet();

      if (response.data?.success == true && response.data?.data != null) {
        return Success(response.data!.data!);
      }

      AppLogger.w('Settings response missing data');
      return ResultFailure(ServerFailure('Settings response missing data'));
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch settings: ${e.message}', e);
      return ResultFailure(dioExceptionToFailure(e));
    } catch (e) {
      AppLogger.e('Failed to fetch settings: $e', e);
      return ResultFailure(exceptionToFailure(e, 'Failed to fetch settings'));
    }
  }

  /// Update settings via API
  Future<Result<PublicSettings>> updateSettings({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    try {
      final client = ApiClientService.getClient();
      final settingsApi = client.getSettingsApi();

      final request = UpdateSettingsRequest((b) {
        b.tmdbApiKey = tmdbApiKey;
        if (scanSettings != null) {
          b.scanSettings.replace(_scanSettingsToApi(scanSettings));
        }
      });

      final response = await settingsApi.apiV1SettingsPut(
        updateSettingsRequest: request,
      );

      if (response.data?.success == true && response.data?.data != null) {
        return Success(response.data!.data!);
      }

      AppLogger.w('Settings update response missing data');
      return ResultFailure(
        ServerFailure('Settings update response missing data'),
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to update settings: ${e.message}', e);
      return ResultFailure(dioExceptionToFailure(e));
    } catch (e) {
      AppLogger.e('Failed to update settings: $e', e);
      return ResultFailure(exceptionToFailure(e, 'Failed to update settings'));
    }
  }

  /// Reset all settings to defaults via API
  Future<Result<PublicSettings>> resetAllSettings() async {
    try {
      final client = ApiClientService.getClient();
      final settingsApi = client.getSettingsApi();

      final response = await settingsApi.apiV1SettingsResetPost();

      if (response.data?.success == true && response.data?.data != null) {
        return Success(response.data!.data!);
      }

      AppLogger.w('Reset all settings response missing data');
      return ResultFailure(
        ServerFailure('Reset all settings response missing data'),
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to reset all settings: ${e.message}', e);
      return ResultFailure(dioExceptionToFailure(e));
    } catch (e) {
      AppLogger.e('Failed to reset all settings: $e', e);
      return ResultFailure(
        exceptionToFailure(e, 'Failed to reset all settings'),
      );
    }
  }

  /// Reset scan settings to defaults via API
  Future<Result<PublicSettings>> resetScanSettings() async {
    try {
      final client = ApiClientService.getClient();
      final settingsApi = client.getSettingsApi();

      final response = await settingsApi.apiV1SettingsResetScanPost();

      if (response.data?.success == true && response.data?.data != null) {
        return Success(response.data!.data!);
      }

      AppLogger.w('Reset scan settings response missing data');
      return ResultFailure(
        ServerFailure('Reset scan settings response missing data'),
      );
    } on DioException catch (e) {
      AppLogger.e('Failed to reset scan settings: ${e.message}', e);
      return ResultFailure(dioExceptionToFailure(e));
    } catch (e) {
      AppLogger.e('Failed to reset scan settings: $e', e);
      return ResultFailure(
        exceptionToFailure(e, 'Failed to reset scan settings'),
      );
    }
  }

  /// Convert domain ScanSettings to UpdateSettingsRequestScanSettings
  static UpdateSettingsRequestScanSettings _scanSettingsToApi(
    ScanSettings scanSettings,
  ) {
    // Convert mediaType string to enum
    UpdateSettingsRequestScanSettingsMediaTypeEnum? mediaTypeEnum;
    if (scanSettings.mediaType != null) {
      if (scanSettings.mediaType == 'movie') {
        mediaTypeEnum = UpdateSettingsRequestScanSettingsMediaTypeEnum.movie;
      } else if (scanSettings.mediaType == 'tv') {
        mediaTypeEnum = UpdateSettingsRequestScanSettingsMediaTypeEnum.tv;
      }
    }

    return UpdateSettingsRequestScanSettings((b) {
      b.mediaType = mediaTypeEnum;
      b.maxDepth = scanSettings.maxDepth;
      if (scanSettings.movieDepth != null || scanSettings.tvDepth != null) {
        b.mediaTypeDepth.replace(
          PublicSettingsScanSettingsMediaTypeDepth(
            (b) => b
              ..movie = scanSettings.movieDepth
              ..tv = scanSettings.tvDepth,
          ),
        );
      }
      if (scanSettings.fileExtensions != null) {
        b.fileExtensions.replace(
          BuiltList<String>(scanSettings.fileExtensions!),
        );
      }
      b.filenamePattern = scanSettings.filenamePattern;
      b.excludePattern = scanSettings.excludePattern;
      b.includePattern = scanSettings.includePattern;
      b.directoryPattern = scanSettings.directoryPattern;
      if (scanSettings.excludeDirectories != null) {
        b.excludeDirectories.replace(
          BuiltList<String>(scanSettings.excludeDirectories!),
        );
      }
      if (scanSettings.includeDirectories != null) {
        b.includeDirectories.replace(
          BuiltList<String>(scanSettings.includeDirectories!),
        );
      }
      b.rescan = scanSettings.rescan;
      b.batchScan = scanSettings.batchScan;
      b.minFileSize = scanSettings.minFileSize;
      b.maxFileSize = scanSettings.maxFileSize;
      b.followSymlinks = scanSettings.followSymlinks;
    });
  }
}
