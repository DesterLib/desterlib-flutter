// Features
import 'package:dester/features/home/domain/entities/movie.dart';

class MovieMapper {
  static Movie fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    if (json['createdAt'] != null) {
      if (json['createdAt'] is DateTime) {
        createdAt = json['createdAt'] as DateTime;
      } else if (json['createdAt'] is String) {
        createdAt = DateTime.tryParse(json['createdAt'] as String);
      }
    }

    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      posterPath: json['posterPath']?.toString(),
      backdropPath: json['backdropPath']?.toString(),
      overview: json['overview']?.toString(),
      releaseDate: json['releaseDate']?.toString(),
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      createdAt: createdAt,
    );
  }

  static List<Movie> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
