import '../entities/movie.dart';

abstract class GetMoviesList {
  Future<List<Movie>> call();
}
