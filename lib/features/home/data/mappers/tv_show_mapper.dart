import '../../domain/entities/tv_show.dart';

class TVShowMapper {
  static TVShow fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      posterPath: json['posterPath']?.toString(),
      backdropPath: json['backdropPath']?.toString(),
      overview: json['overview']?.toString(),
      firstAirDate: json['firstAirDate']?.toString(),
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }

  static List<TVShow> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
