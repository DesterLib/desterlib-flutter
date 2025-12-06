// Features
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'package:dester/features/media_details/domain/repository/media_details_repository.dart';

/// Use case for getting TV show details
abstract class GetTVShowDetails {
  Future<TVShow> call(String id);
}

/// Implementation of GetTVShowDetails use case
class GetTVShowDetailsImpl implements GetTVShowDetails {
  final MediaDetailsRepository repository;

  GetTVShowDetailsImpl({required this.repository});

  @override
  Future<TVShow> call(String id) {
    return repository.getTVShowDetails(id);
  }
}
