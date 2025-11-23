// Features
import 'package:dester/features/home/domain/entities/movie.dart';


abstract class GetMoviesList {
  Future<List<Movie>> call();
}
