// Features
import 'package:dester/features/settings/domain/entities/settings.dart';


/// Use case interface for getting settings
abstract class GetSettings {
  Future<Settings> call();
}
