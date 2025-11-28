// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';

import 'reset_settings.dart';

/// Implementation of ResetAllSettings use case
class ResetAllSettingsImpl implements ResetAllSettings {
  final SettingsRepository repository;

  ResetAllSettingsImpl(this.repository);

  @override
  Future<Result<Settings>> call() async {
    return await repository.resetAllSettings();
  }
}

/// Implementation of ResetScanSettings use case
class ResetScanSettingsImpl implements ResetScanSettings {
  final SettingsRepository repository;

  ResetScanSettingsImpl(this.repository);

  @override
  Future<Result<Settings>> call() async {
    return await repository.resetScanSettings();
  }
}
