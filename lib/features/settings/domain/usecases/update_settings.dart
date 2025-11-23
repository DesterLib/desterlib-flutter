// Features
import 'package:dester/features/settings/domain/entities/settings.dart';


/// Use case interface for updating settings
abstract class UpdateSettings {
  Future<Settings> call({String? tmdbApiKey});
}
