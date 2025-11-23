// External packages
import 'package:openapi/openapi.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';


/// Mapper for converting API models to domain entities
class SettingsMapper {
  /// Convert OpenAPI PublicSettings to domain Settings entity
  static Settings fromApiModel(PublicSettings? apiSettings) {
    if (apiSettings == null) {
      return const Settings(firstRun: true);
    }

    return Settings(
      tmdbApiKey: apiSettings.tmdbApiKey,
      firstRun: apiSettings.firstRun ?? true,
    );
  }
}
