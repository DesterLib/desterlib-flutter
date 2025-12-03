// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/network/dester_api.dart';
import 'package:dester/core/network/models/settings_models.dart';
import 'package:dester/core/network/mappers/settings_mapper.dart';
import 'package:dester/core/network/api_exception.dart';
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';

/// Data source for settings operations using the new clean API
class SettingsDataSource {
  final DesterApi _api;

  SettingsDataSource(this._api);

  /// Get current settings from the API
  Future<Result<Settings>> getSettings() async {
    try {
      final dto = await _api.settings.getSettings();
      final settings = SettingsApiMapper.toDomain(dto);
      return Success(settings);
    } on ApiException catch (e) {
      AppLogger.e('Failed to fetch settings: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch settings: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to fetch settings'));
    }
  }

  /// Update settings via API
  Future<Result<Settings>> updateSettings({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    try {
      final request = UpdateSettingsRequestDto(
        tmdbApiKey: tmdbApiKey,
        scanSettings: scanSettings != null
            ? SettingsApiMapper.scanSettingsToDto(scanSettings)
            : null,
      );

      final dto = await _api.settings.updateSettings(request);
      final settings = SettingsApiMapper.toDomain(dto);
      return Success(settings);
    } on ApiException catch (e) {
      AppLogger.e('Failed to update settings: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to update settings: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to update settings'));
    }
  }

  /// Complete first run setup
  Future<Result<void>> completeFirstRun() async {
    try {
      await _api.settings.completeFirstRun();
      return const Success(null);
    } on ApiException catch (e) {
      AppLogger.e('Failed to complete first run: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to complete first run: $e', e, stackTrace);
      return ResultFailure(
        exceptionToFailure(e, 'Failed to complete first run'),
      );
    }
  }

  /// Reset scan settings to defaults
  Future<Result<Settings>> resetScanSettings() async {
    try {
      final dto = await _api.settings.resetScanSettings();
      final settings = SettingsApiMapper.toDomain(dto);
      return Success(settings);
    } on ApiException catch (e) {
      AppLogger.e('Failed to reset scan settings: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to reset scan settings: $e', e, stackTrace);
      return ResultFailure(
        exceptionToFailure(e, 'Failed to reset scan settings'),
      );
    }
  }
}
