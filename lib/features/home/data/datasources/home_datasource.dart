// External packages
import 'package:dio/dio.dart';

// Core
import 'package:dester/core/network/api_client_service.dart';

/// API client for fetching data from the server
class HomeDataSource {
  // Get movies list from API
  Future<List<Map<String, dynamic>>> getMoviesList() async {
    try {
      final client = ApiClientService.getClient();
      final moviesApi = client.getMoviesApi();
      final response = await moviesApi.apiV1MoviesGet();

      if (response.data?.success == true && response.data?.data != null) {
        final movies = response.data!.data!;
        return movies.map((movie) {
          final media = movie.media;
          return {
            'id': movie.id ?? '',
            'title': media?.title ?? '',
            'posterPath': media?.posterUrl,
            'plainPosterUrl': media?.plainPosterUrl,
            'backdropPath': media?.backdropUrl,
            'logoUrl': media?.logoUrl,
            'overview': media?.description,
            'releaseDate': media?.releaseDate
                ?.toIso8601String()
                .split('T')
                .first,
            'rating': media?.rating?.toDouble(),
            'meshGradientColors': media?.meshGradientColors != null
                ? media!.meshGradientColors!.toList()
                : null,
            'createdAt': media?.createdAt,
          };
        }).toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception('Failed to fetch movies: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  // Get TV shows list from API
  Future<List<Map<String, dynamic>>> getTVShowsList() async {
    try {
      final client = ApiClientService.getClient();
      final tvShowsApi = client.getTVShowsApi();
      final response = await tvShowsApi.apiV1TvshowsGet();

      if (response.data?.success == true && response.data?.data != null) {
        final tvShows = response.data!.data!;
        return tvShows.map((tvShow) {
          final media = tvShow.media;
          return {
            'id': tvShow.id ?? '',
            'title': media?.title ?? '',
            'posterPath': media?.posterUrl,
            'plainPosterUrl': media?.plainPosterUrl,
            'backdropPath': media?.backdropUrl,
            'logoUrl': media?.logoUrl,
            'overview': media?.description,
            'firstAirDate': media?.releaseDate
                ?.toIso8601String()
                .split('T')
                .first,
            'rating': media?.rating?.toDouble(),
            'meshGradientColors': media?.meshGradientColors != null
                ? media!.meshGradientColors!.toList()
                : null,
            'createdAt': media?.createdAt,
          };
        }).toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception('Failed to fetch TV shows: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch TV shows: $e');
    }
  }
}
