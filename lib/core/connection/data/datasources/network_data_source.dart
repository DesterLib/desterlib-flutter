import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/connection_status.dart';

/// Data source for network connectivity
abstract class NetworkDataSource {
  Future<bool> hasInternetConnectivity();
  Future<ConnectionStatus> checkApiConnection(String apiUrl);
}

/// Implementation of network data source
class NetworkDataSourceImpl implements NetworkDataSource {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> hasInternetConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      AppLogger.d('Connectivity check results: $connectivityResults');

      // Explicitly check for none first
      if (connectivityResults.contains(ConnectivityResult.none) &&
          connectivityResults.length == 1) {
        AppLogger.d('No internet connectivity detected');
        return false;
      }

      // Check for active connectivity types
      final hasConnectivity = connectivityResults.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn,
      );
      AppLogger.d('Internet connectivity: $hasConnectivity');
      return hasConnectivity;
    } catch (e, stackTrace) {
      AppLogger.e('Error checking internet connectivity', e, stackTrace);
      return false;
    }
  }

  @override
  Future<ConnectionStatus> checkApiConnection(String apiUrl) async {
    try {
      AppLogger.d('Checking API connection to: $apiUrl');
      final uri = Uri.parse(apiUrl);
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode >= 200 && response.statusCode < 500) {
        AppLogger.i('API connection successful: ${response.statusCode}');
        return ConnectionStatus.connected;
      } else {
        AppLogger.w(
          'API connection failed with status: ${response.statusCode}',
        );
        return ConnectionStatus.error;
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error checking API connection to $apiUrl', e, stackTrace);
      return ConnectionStatus.error;
    }
  }
}
