// Features
import 'package:dester/features/settings/domain/entities/settings.dart';


/// Repository interface for settings operations
abstract class SettingsRepository {
  /// Get current settings
  Future<Settings> getSettings();

  /// Update settings
  Future<Settings> updateSettings({String? tmdbApiKey});
}
