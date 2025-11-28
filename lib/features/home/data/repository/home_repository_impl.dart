// Core
import 'package:dester/core/errors/errors.dart';

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

    return result.map((moviesJson) {
      // Convert to domain entities
      return moviesJson.map((json) => MovieMapper.fromJson(json)).toList();
    });
  }

  @override
  Future<Result<List<TVShow>>> getTVShows() async {
    // Get data from API
    final result = await dataSource.getTVShowsList();

    return result.map((tvShowsJson) {
      // Convert to domain entities
      return tvShowsJson.map((json) => TVShowMapper.fromJson(json)).toList();
    });
  }
}
