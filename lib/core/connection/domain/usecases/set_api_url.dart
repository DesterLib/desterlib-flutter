import '../entities/connection_status.dart';

/// Use case interface for setting API URL
abstract class SetApiUrl {
  Future<ConnectionGuardState> call(String url);
}
