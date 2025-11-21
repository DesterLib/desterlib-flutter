import '../entities/movie.dart';
import '../repository/home_repository.dart';
import 'get_movies_list.dart';

class GetMoviesListImpl implements GetMoviesList {
  final HomeRepository repository;

  GetMoviesListImpl(this.repository);

  @override
  Future<List<Movie>> call() async {
    return await repository.getMovies();
  }
}
