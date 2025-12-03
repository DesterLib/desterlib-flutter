// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/network/dester_api.dart';
import 'package:dester/core/network/api_exception.dart';
import 'package:dester/core/utils/app_logger.dart';

/// API client for fetching data from the server using the new clean API
class HomeDataSource {
  final DesterApi _api;

  HomeDataSource(this._api);

  /// Get movies list from API
  Future<Result<List<Map<String, dynamic>>>> getMoviesList() async {
    try {
      final movies = await _api.movies.getMovies();

      final moviesList = movies.map((movie) {
        return {
          'id': movie.id,
          'title': movie.title,
          'posterPath': movie.posterUrl,
          'backdropPath': movie.backdropUrl,
          'nullPosterUrl': movie.nullPosterUrl,
          'logoUrl': movie.logoUrl,
          'overview': movie.overview,
          'releaseDate': movie.releaseDate?.toIso8601String().split('T').first,
          'rating': movie.rating,
          'genres': movie.genres?.map((g) => g.name).toList(),
          'createdAt': movie.createdAt?.toIso8601String(),
        };
      }).toList();

      if (moviesList.isNotEmpty) {
        AppLogger.d(
          'First movie extracted: id=${moviesList[0]['id']}, title=${moviesList[0]['title']}',
        );
      }

      return Success(moviesList);
    } on ApiException catch (e) {
      AppLogger.e('Failed to fetch movies: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch movies: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to fetch movies'));
    }
  }

  /// Get TV shows list from API
  Future<Result<List<Map<String, dynamic>>>> getTVShowsList() async {
    try {
      final tvShows = await _api.tvShows.getTvShows();

      final tvShowsList = tvShows.map((show) {
        return {
          'id': show.id,
          'title': show.title,
          'posterPath': show.posterUrl,
          'backdropPath': show.backdropUrl,
          'nullPosterUrl': show.nullPosterUrl,
          'logoUrl': show.logoUrl,
          'overview': show.overview,
          'firstAirDate': show.firstAirDate?.toIso8601String().split('T').first,
          'rating': show.rating,
          'genres': show.genres?.map((g) => g.name).toList(),
          'createdAt': show.createdAt?.toIso8601String(),
        };
      }).toList();

      return Success(tvShowsList);
    } on ApiException catch (e) {
      AppLogger.e('Failed to fetch TV shows: ${e.message}', e);
      return ResultFailure(e.toFailure());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch TV shows: $e', e, stackTrace);
      return ResultFailure(exceptionToFailure(e, 'Failed to fetch TV shows'));
    }
  }
}
