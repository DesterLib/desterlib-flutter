// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/repository/home_repository.dart';

import 'get_movies_list.dart';

class GetMoviesListImpl implements GetMoviesList {
  final HomeRepository repository;

  GetMoviesListImpl(this.repository);

  @override
  Future<Result<List<Movie>>> call() async {
    return await repository.getMovies();
  }
}
