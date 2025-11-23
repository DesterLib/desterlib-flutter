// Core
import 'package:dester/core/connection/domain/entities/connection_status.dart';


/// Use case interface for setting an API configuration as active
abstract class SetActiveApiConfiguration {
  Future<ConnectionGuardState> call(String configurationId);
}
