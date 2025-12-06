// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';

/// Repository interface for media details
abstract class MediaDetailsRepository {
  /// Get movie details by ID
  Future<Movie> getMovieDetails(String id);

  /// Get TV show details by ID
  Future<TVShow> getTVShowDetails(String id);
}
