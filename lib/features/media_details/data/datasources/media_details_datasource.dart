// Core
import 'package:dester/core/network/dester_api.dart';
import 'package:dester/core/network/models/media_models.dart';

/// Data source for fetching media details
class MediaDetailsDatasource {
  final DesterApi api;

  MediaDetailsDatasource({required this.api});

  /// Fetch movie details by ID
  Future<MovieDto> getMovieDetails(String id) async {
    try {
      return await api.movies.getMovieById(id);
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }

  /// Fetch TV show details by ID
  Future<TvShowDto> getTVShowDetails(String id) async {
    try {
      return await api.tvShows.getTvShowById(id);
    } catch (e) {
      throw Exception('Failed to fetch TV show details: $e');
    }
  }
}
