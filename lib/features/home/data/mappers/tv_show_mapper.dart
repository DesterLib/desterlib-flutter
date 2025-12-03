// Features
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'media_mapper_utils.dart';

class TVShowMapper {
  static TVShow fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      posterPath: MediaMapperUtils.parseString(json['posterPath']),
      nullPosterUrl: MediaMapperUtils.parseString(json['nullPosterUrl']),
      logoUrl: MediaMapperUtils.parseString(json['logoUrl']),
      backdropPath: MediaMapperUtils.parseString(json['backdropPath']),
      overview: MediaMapperUtils.parseString(json['overview']),
      firstAirDate: MediaMapperUtils.parseString(json['firstAirDate']),
      rating: MediaMapperUtils.parseRating(json['rating']),
      genres: MediaMapperUtils.parseGenres(json['genres']),
      meshGradientColors: MediaMapperUtils.parseMeshGradientColors(
        json['meshGradientColors'],
      ),
      createdAt: MediaMapperUtils.parseCreatedAt(json['createdAt']),
    );
  }

  static List<TVShow> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
