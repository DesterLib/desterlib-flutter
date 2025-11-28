// Core
import 'package:dester/features/connection/domain/entities/connection_status.dart';


/// Use case interface for deleting an API configuration
abstract class DeleteApiConfiguration {
  Future<ConnectionGuardState> call(String configurationId);
}
