// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';

/// Use case interface for resetting all settings to defaults
abstract class ResetAllSettings {
  Future<Result<Settings>> call();
}

/// Use case interface for resetting scan settings to defaults
abstract class ResetScanSettings {
  Future<Result<Settings>> call();
}
