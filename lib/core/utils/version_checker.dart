/// Utility class for checking version compatibility between client and API
class VersionChecker {
  /// Parse semantic version string to compare
  static Map<String, int>? parseVersion(String version) {
    final match = RegExp(r'^(\d+)\.(\d+)\.(\d+)').firstMatch(version);
    if (match == null) return null;

    return {
      'major': int.parse(match.group(1)!),
      'minor': int.parse(match.group(2)!),
      'patch': int.parse(match.group(3)!),
    };
  }

  /// Check if client version is compatible with API version
  /// Major and minor versions must match, patch version can differ
  static bool isVersionCompatible(String clientVersion, String apiVersion) {
    final client = parseVersion(clientVersion);
    final api = parseVersion(apiVersion);

    if (client == null || api == null) return false;

    // Major version must match
    if (client['major'] != api['major']) return false;

    // Minor version must match (we enforce strict minor version matching)
    if (client['minor'] != api['minor']) return false;

    // Patch version can differ (backwards compatible)
    return true;
  }

  /// Get a user-friendly error message for version mismatch
  static String getVersionMismatchMessage(
    String clientVersion,
    String apiVersion,
  ) {
    final client = parseVersion(clientVersion);
    final api = parseVersion(apiVersion);

    if (client == null || api == null) {
      return 'Invalid version format. Client: $clientVersion, API: $apiVersion';
    }

    if (client['major'] != api['major']) {
      return 'Major version mismatch. Please update your app to version $apiVersion';
    }

    if (client['minor'] != api['minor']) {
      return 'Minor version mismatch. Please update your app to version $apiVersion';
    }

    return 'Version mismatch. Client: $clientVersion, API: $apiVersion';
  }

  /// Compare versions and return comparison result
  /// Returns:
  ///   -1 if client version is older
  ///    0 if versions are equal
  ///    1 if client version is newer
  static int compareVersions(String clientVersion, String apiVersion) {
    final client = parseVersion(clientVersion);
    final api = parseVersion(apiVersion);

    if (client == null || api == null) return 0;

    // Compare major version
    if (client['major']! < api['major']!) return -1;
    if (client['major']! > api['major']!) return 1;

    // Compare minor version
    if (client['minor']! < api['minor']!) return -1;
    if (client['minor']! > api['minor']!) return 1;

    // Compare patch version
    if (client['patch']! < api['patch']!) return -1;
    if (client['patch']! > api['patch']!) return 1;

    return 0;
  }
}
