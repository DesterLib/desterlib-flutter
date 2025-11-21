import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
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
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  @override
  Future<ConnectionStatus> checkApiConnection(String apiUrl) async {
    try {
      final uri = Uri.parse(apiUrl);
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode >= 200 && response.statusCode < 500) {
        return ConnectionStatus.connected;
      } else {
        return ConnectionStatus.error;
      }
    } catch (e) {
      return ConnectionStatus.error;
    }
  }
}
