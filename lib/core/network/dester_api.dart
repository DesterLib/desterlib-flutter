import 'api_client.dart';
import 'api/settings_api.dart';
import 'api/library_api.dart';
import 'api/scan_api.dart';
import 'api/movies_api.dart';
import 'api/tvshows_api.dart';
import 'api/search_api.dart';
import 'api/health_api.dart';

/// Simple, easy-to-use API interface for DesterLib
///
/// Usage:
/// ```dart
/// final api = DesterApi(baseUrl: 'http://localhost:3000');
///
/// // Get settings
/// final settings = await api.settings.getSettings();
///
/// // Scan a path
/// await api.scan.scanPath(...);
///
/// // Get libraries
/// final libraries = await api.library.getLibraries();
///
/// // Get movies/TV shows
/// final movies = await api.movies.getMovies();
/// final tvShows = await api.tvShows.getTvShows();
///
/// // Search
/// final results = await api.search.search('Matrix');
/// ```
class DesterApi {
  final ApiClient _client;

  /// Get the base URL of this API instance
  String get baseUrl => _client.baseUrl;

  late final SettingsApi settings;
  late final LibraryApi library;
  late final ScanApi scan;
  late final MoviesApi movies;
  late final TvShowsApi tvShows;
  late final SearchApi search;
  late final HealthApi health;

  DesterApi({
    required String baseUrl,
    Duration? timeout,
    Map<String, dynamic>? headers,
  }) : _client = ApiClient(
         baseUrl: baseUrl,
         connectTimeout: timeout,
         receiveTimeout: timeout,
         sendTimeout: timeout,
         headers: headers,
       ) {
    // Initialize API endpoints
    settings = SettingsApi(_client);
    library = LibraryApi(_client);
    scan = ScanApi(_client);
    movies = MoviesApi(_client);
    tvShows = TvShowsApi(_client);
    search = SearchApi(_client);
    health = HealthApi(_client);
  }

  /// Update the base URL (useful for server discovery)
  void updateBaseUrl(String newBaseUrl) {
    _client.updateBaseUrl(newBaseUrl);
  }

  /// Add custom header
  void addHeader(String key, String value) {
    _client.addHeader(key, value);
  }

  /// Remove header
  void removeHeader(String key) {
    _client.removeHeader(key);
  }

  /// Close and clean up resources
  void dispose() {
    _client.close();
  }
}
