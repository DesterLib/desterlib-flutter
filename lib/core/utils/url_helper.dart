/// Helper utilities for URL normalization and handling
class UrlHelper {
  /// Normalize a URL by replacing 'localhost' with '127.0.0.1'
  /// This ensures better compatibility across platforms, especially on simulators/emulators
  static String normalizeUrl(String url) {
    // Replace localhost with 127.0.0.1 for better cross-platform compatibility
    // This is especially important for iOS simulators and Android emulators
    return url.replaceAll('localhost', '127.0.0.1');
  }

  /// Validate and normalize a URL
  /// Returns the normalized URL if valid, null otherwise
  static String? validateAndNormalize(String url) {
    if (url.trim().isEmpty) {
      return null;
    }

    try {
      final uri = Uri.parse(url.trim());
      // Check if URL has a valid scheme (http, https, etc.)
      if (!uri.hasScheme) {
        return null;
      }
      // Check if URL has a valid host or authority
      if (uri.host.isEmpty && !uri.hasAuthority) {
        return null;
      }
      return normalizeUrl(url.trim());
    } catch (e) {
      return null;
    }
  }
}
