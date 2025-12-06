// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/media_details/domain/repository/media_details_repository.dart';

/// Use case for getting movie details
abstract class GetMovieDetails {
  Future<Movie> call(String id);
}

/// Implementation of GetMovieDetails use case
class GetMovieDetailsImpl implements GetMovieDetails {
  final MediaDetailsRepository repository;

  GetMovieDetailsImpl({required this.repository});

  @override
  Future<Movie> call(String id) {
    return repository.getMovieDetails(id);
  }
}
