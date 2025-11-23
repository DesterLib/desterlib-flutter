// Core
import 'package:dester/core/connection/domain/entities/connection_status.dart';


/// Use case interface for adding a new API configuration
abstract class AddApiConfiguration {
  Future<ConnectionGuardState> call(
    String url,
    String label, {
    bool setAsActive = false,
  });
}
