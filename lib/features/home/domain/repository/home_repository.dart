// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';


// Repository interface (domain layer)
abstract class HomeRepository {
  Future<List<Movie>> getMovies();
  Future<List<TVShow>> getTVShows();
}
