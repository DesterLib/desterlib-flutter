import '../entities/connection_status.dart';

/// Use case interface for checking connection
abstract class CheckConnection {
  Future<ConnectionGuardState> call();
}
