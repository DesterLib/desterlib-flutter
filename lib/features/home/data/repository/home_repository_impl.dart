import '../../domain/entities/movie.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/repository/home_repository.dart';
import '../datasources/home_datasource.dart';
import '../mappers/movie_mapper.dart';
import '../mappers/tv_show_mapper.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<List<Movie>> getMovies() async {
    // Get data from API
    final moviesJson = await dataSource.getMoviesList();

    // Convert to domain entities
    final movies = moviesJson
        .map((json) => MovieMapper.fromJson(json))
        .toList();

    return movies;
  }

  @override
  Future<List<TVShow>> getTVShows() async {
    // Get data from API
    final tvShowsJson = await dataSource.getTVShowsList();

    // Convert to domain entities
    final tvShows = tvShowsJson
        .map((json) => TVShowMapper.fromJson(json))
        .toList();

    return tvShows;
  }
}
