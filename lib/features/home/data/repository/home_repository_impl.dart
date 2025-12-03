// Core
import 'package:dester/core/errors/errors.dart';
import 'package:dester/core/utils/color_extractor.dart';

// Features
import 'package:dester/features/home/data/datasources/home_datasource.dart';
import 'package:dester/features/home/data/mappers/movie_mapper.dart';
import 'package:dester/features/home/data/mappers/tv_show_mapper.dart';
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'package:dester/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<Result<List<Movie>>> getMovies() async {
    // Get data from API
    final result = await dataSource.getMoviesList();

    return result.mapAsync((moviesJson) async {
      // Convert to domain entities
      final movies = moviesJson
          .map((json) => MovieMapper.fromJson(json))
          .toList();

      // Enrich movies with colors extracted on client side
      final enrichedMovies = await _enrichMoviesWithColors(movies);
      return enrichedMovies;
    });
  }

  @override
  Future<Result<List<TVShow>>> getTVShows() async {
    // Get data from API
    final result = await dataSource.getTVShowsList();

    return result.mapAsync((tvShowsJson) async {
      // Convert to domain entities
      final tvShows = tvShowsJson
          .map((json) => TVShowMapper.fromJson(json))
          .toList();

      // Enrich TV shows with colors extracted on client side
      final enrichedTVShows = await _enrichTVShowsWithColors(tvShows);
      return enrichedTVShows;
    });
  }

  /// Extract colors from movie posters/backdrops if not already present
  Future<List<Movie>> _enrichMoviesWithColors(List<Movie> movies) async {
    final enrichedMovies = <Movie>[];

    for (final movie in movies) {
      // Skip if colors already exist
      if (movie.meshGradientColors != null &&
          movie.meshGradientColors!.length == 4) {
        enrichedMovies.add(movie);
        continue;
      }

      // Try to extract colors from poster, fallback to backdrop
      final imageUrl = movie.posterPath ?? movie.backdropPath;
      final colors = await ColorExtractor.extractColorsFromUrl(imageUrl);

      // Create new movie with extracted colors
      enrichedMovies.add(
        Movie(
          id: movie.id,
          title: movie.title,
          posterPath: movie.posterPath,
          backdropPath: movie.backdropPath,
          nullPosterUrl: movie.nullPosterUrl,
          logoUrl: movie.logoUrl,
          overview: movie.overview,
          releaseDate: movie.releaseDate,
          rating: movie.rating,
          genres: movie.genres,
          meshGradientColors: colors ?? movie.meshGradientColors,
          createdAt: movie.createdAt,
        ),
      );
    }

    return enrichedMovies;
  }

  /// Extract colors from TV show posters/backdrops if not already present
  Future<List<TVShow>> _enrichTVShowsWithColors(List<TVShow> tvShows) async {
    final enrichedTVShows = <TVShow>[];

    for (final tvShow in tvShows) {
      // Skip if colors already exist
      if (tvShow.meshGradientColors != null &&
          tvShow.meshGradientColors!.length == 4) {
        enrichedTVShows.add(tvShow);
        continue;
      }

      // Try to extract colors from poster, fallback to backdrop
      final imageUrl = tvShow.posterPath ?? tvShow.backdropPath;
      final colors = await ColorExtractor.extractColorsFromUrl(imageUrl);

      // Create new TV show with extracted colors
      enrichedTVShows.add(
        TVShow(
          id: tvShow.id,
          title: tvShow.title,
          posterPath: tvShow.posterPath,
          backdropPath: tvShow.backdropPath,
          nullPosterUrl: tvShow.nullPosterUrl,
          logoUrl: tvShow.logoUrl,
          overview: tvShow.overview,
          firstAirDate: tvShow.firstAirDate,
          rating: tvShow.rating,
          genres: tvShow.genres,
          meshGradientColors: colors ?? tvShow.meshGradientColors,
          createdAt: tvShow.createdAt,
        ),
      );
    }

    return enrichedTVShows;
  }
}
