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
