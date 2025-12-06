// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'package:dester/features/home/data/mappers/movie_mapper.dart';
import 'package:dester/features/home/data/mappers/tv_show_mapper.dart';
import 'package:dester/features/media_details/domain/repository/media_details_repository.dart';
import 'package:dester/features/media_details/data/datasources/media_details_datasource.dart';

/// Implementation of MediaDetailsRepository
class MediaDetailsRepositoryImpl implements MediaDetailsRepository {
  final MediaDetailsDatasource datasource;

  MediaDetailsRepositoryImpl({required this.datasource});

  @override
  Future<Movie> getMovieDetails(String id) async {
    final dto = await datasource.getMovieDetails(id);

    // Convert DTO to Map for the mapper
    final movieMap = {
      'id': dto.id,
      'title': dto.title,
      'posterPath': dto.posterUrl,
      'backdropPath': dto.backdropUrl,
      'nullPosterUrl': dto.nullPosterUrl,
      'nullBackdropUrl': dto.nullBackdropUrl,
      'logoUrl': dto.logoUrl,
      'overview': dto.overview,
      'releaseDate': dto.releaseDate?.toIso8601String().split('T').first,
      'rating': dto.rating,
      'genres': dto.genres?.map((g) => g.name).toList(),
      'meshGradientColors': dto.meshGradientColors,
      'createdAt': dto.createdAt?.toIso8601String(),
    };

    return MovieMapper.fromJson(movieMap);
  }

  @override
  Future<TVShow> getTVShowDetails(String id) async {
    final dto = await datasource.getTVShowDetails(id);

    // Convert DTO to Map for the mapper
    final tvShowMap = {
      'id': dto.id,
      'title': dto.title,
      'posterPath': dto.posterUrl,
      'backdropPath': dto.backdropUrl,
      'nullPosterUrl': dto.nullPosterUrl,
      'nullBackdropUrl': dto.nullBackdropUrl,
      'logoUrl': dto.logoUrl,
      'overview': dto.overview,
      'firstAirDate': dto.firstAirDate?.toIso8601String().split('T').first,
      'rating': dto.rating,
      'genres': dto.genres?.map((g) => g.name).toList(),
      'meshGradientColors': dto.meshGradientColors,
      'createdAt': dto.createdAt?.toIso8601String(),
    };

    return TVShowMapper.fromJson(tvShowMap);
  }
}
