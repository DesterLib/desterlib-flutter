// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';

/// Use case interface for updating settings
abstract class UpdateSettings {
  Future<Result<Settings>> call({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  });
}
