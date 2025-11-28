// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/home/domain/entities/movie.dart';

abstract class GetMoviesList {
  Future<Result<List<Movie>>> call();
}
