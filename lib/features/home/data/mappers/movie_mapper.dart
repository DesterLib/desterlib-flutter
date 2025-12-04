// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'media_mapper_utils.dart';

class MovieMapper {
  static Movie fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      posterPath: MediaMapperUtils.parseString(json['posterPath']),
      nullPosterUrl: MediaMapperUtils.parseString(json['nullPosterUrl']),
      logoUrl: MediaMapperUtils.parseString(json['logoUrl']),
      backdropPath: MediaMapperUtils.parseString(json['backdropPath']),
      nullBackdropUrl: MediaMapperUtils.parseString(json['nullBackdropUrl']),
      overview: MediaMapperUtils.parseString(json['overview']),
      releaseDate: MediaMapperUtils.parseString(json['releaseDate']),
      rating: MediaMapperUtils.parseRating(json['rating']),
      genres: MediaMapperUtils.parseGenres(json['genres']),
      meshGradientColors: MediaMapperUtils.parseMeshGradientColors(
        json['meshGradientColors'],
      ),
      createdAt: MediaMapperUtils.parseCreatedAt(json['createdAt']),
    );
  }

  static List<Movie> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
