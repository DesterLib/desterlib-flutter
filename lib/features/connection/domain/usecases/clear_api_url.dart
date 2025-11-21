import '../entities/connection_status.dart';

/// Use case interface for clearing API URL
abstract class ClearApiUrl {
  Future<ConnectionGuardState> call();
}
