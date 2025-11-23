// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';

import 'get_settings.dart';


/// Implementation of GetSettings use case
class GetSettingsImpl implements GetSettings {
  final SettingsRepository repository;

  GetSettingsImpl(this.repository);

  @override
  Future<Settings> call() async {
    return await repository.getSettings();
  }
}
