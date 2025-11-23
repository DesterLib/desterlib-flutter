// Core
import 'package:dester/core/connection/domain/entities/connection_status.dart';


/// Use case interface for checking connection
abstract class CheckConnection {
  Future<ConnectionGuardState> call();
}
