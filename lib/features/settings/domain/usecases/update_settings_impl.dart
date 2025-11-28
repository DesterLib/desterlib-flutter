// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';

import 'update_settings.dart';

/// Implementation of UpdateSettings use case
class UpdateSettingsImpl implements UpdateSettings {
  final SettingsRepository repository;

  UpdateSettingsImpl(this.repository);

  @override
  Future<Result<Settings>> call({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    return await repository.updateSettings(
      tmdbApiKey: tmdbApiKey,
      scanSettings: scanSettings,
    );
  }
}
