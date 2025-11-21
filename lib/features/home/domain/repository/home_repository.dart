import '../entities/movie.dart';
import '../entities/tv_show.dart';

// Repository interface (domain layer)
abstract class HomeRepository {
  Future<List<Movie>> getMovies();
  Future<List<TVShow>> getTVShows();
}
