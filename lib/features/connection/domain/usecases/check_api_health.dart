// Features
import 'package:dester/features/connection/domain/entities/api_health.dart';

/// Use case for checking API health
/// Returns ApiHealth with status and optional error information
abstract class CheckApiHealth {
  /// Check health of the given API URL
  /// Returns ApiHealth with current health status
  Future<ApiHealth> call(String url);
}
