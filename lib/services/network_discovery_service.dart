import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

class NetworkDiscoveryService {
  static const int _timeoutSeconds = 2;
  static const int _maxConcurrentRequests = 50;

  /// Discovers the DesterLib API on the local network
  /// Returns the first found server URL or null if none found
  static Future<String?> discoverApiServer() async {
    try {
      final networkInfo = NetworkInfo();

      // Get local IP address
      String? wifiIP = await networkInfo.getWifiIP();
      if (wifiIP == null) {
        return null;
      }

      // Extract network prefix (e.g., 192.168.1 from 192.168.1.100)
      final ipParts = wifiIP.split('.');
      if (ipParts.length != 4) {
        return null;
      }

      final networkPrefix = '${ipParts[0]}.${ipParts[1]}.${ipParts[2]}';

      // Check common API server IPs first (same subnet, sequential scan)
      final candidates = <String>[];

      candidates.add(wifiIP);

      // Add gateway IP (common for routers with port forwarding)
      final gatewayIP = await networkInfo.getWifiGatewayIP();
      if (gatewayIP != null) {
        candidates.add(gatewayIP);
      }

      // Add common router IPs
      candidates.addAll([
        '$networkPrefix.1',
        '$networkPrefix.254',
        '$networkPrefix.2',
        '$networkPrefix.10',
        '$networkPrefix.20',
        '$networkPrefix.100',
      ]);

      // Remove duplicates and invalid IPs
      final uniqueCandidates = candidates
          .toSet()
          .where((ip) => _isValidIP(ip))
          .toList();

      // Test candidates concurrently in batches
      final results = await _testCandidatesInBatches(uniqueCandidates);

      if (results.isNotEmpty) {
        final foundServer = results.first;
        return 'http://$foundServer:3001';
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Tests candidate IPs in batches to avoid overwhelming the network
  static Future<List<String>> _testCandidatesInBatches(
    List<String> candidates,
  ) async {
    final results = <String>[];
    final batchSize = _maxConcurrentRequests;

    for (int i = 0; i < candidates.length; i += batchSize) {
      final batch = candidates.skip(i).take(batchSize).toList();
      final batchResults = await Future.wait(
        batch.map((ip) => _testApiEndpoint('http://$ip:3001')),
        eagerError: false,
      );

      // Add successful results
      for (int j = 0; j < batchResults.length; j++) {
        if (batchResults[j] == true) {
          results.add(batch[j]);
        }
      }

      // If we found a server, we can stop early
      if (results.isNotEmpty) {
        break;
      }
    }

    return results;
  }

  /// Tests if an API endpoint is reachable
  static Future<bool> _testApiEndpoint(String url) async {
    try {
      final uri = Uri.parse('$url/health');
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: _timeoutSeconds));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Checks if an IP address is valid
  static bool _isValidIP(String ip) {
    try {
      final parts = ip.split('.');
      if (parts.length != 4) return false;

      for (final part in parts) {
        final num = int.parse(part);
        if (num < 0 || num > 255) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets the best available server URL for the current platform
  /// Falls back to localhost URLs if no network server is found
  static Future<String> getBestServerUrl() async {
    // First try to discover on the network
    final discoveredUrl = await discoverApiServer();
    if (discoveredUrl != null) {
      return discoveredUrl;
    }

    // Try localhost variants first
    final localhostVariants = ['localhost', '127.0.0.1'];

    for (final host in localhostVariants) {
      if (await _testApiEndpoint('http://$host:3001')) {
        return 'http://$host:3001';
      }
    }

    // Try common local network ranges
    final commonRanges = [
      ['192.168.1', 1, 50],
      ['192.168.0', 1, 50],
      ['10.0.0', 1, 20],
    ];

    for (final range in commonRanges) {
      final prefix = range[0] as String;
      final start = range[1] as int;
      final end = range[2] as int;

      final candidates = <String>[];
      for (int i = start; i <= end; i++) {
        candidates.add('$prefix.$i');
      }

      final results = await _testCandidatesInBatches(candidates);
      if (results.isNotEmpty) {
        final foundServer = results.first;
        return 'http://$foundServer:3001';
      }
    }

    // Final fallback to platform-specific localhost URLs
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3001';
    } else if (Platform.isMacOS) {
      return 'http://localhost:3001';
    } else {
      return 'http://127.0.0.1:3001';
    }
  }
}
