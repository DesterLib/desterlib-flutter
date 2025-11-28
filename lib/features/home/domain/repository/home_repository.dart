// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';

// Repository interface (domain layer)
abstract class HomeRepository {
  Future<Result<List<Movie>>> getMovies();
  Future<Result<List<TVShow>>> getTVShows();
}
