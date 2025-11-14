/// Data model for media details
class MediaData {
  final String id;
  final String title;
  final String year;
  final String duration;
  final String rating;
  final List<String> genres;
  final String description;
  final String director;
  final List<String> cast;
  final String? posterUrl;
  final String? backdropUrl;
  final List<String>? meshGradientColors; // Hex color strings for mesh gradient

  const MediaData({
    required this.id,
    required this.title,
    required this.year,
    required this.duration,
    required this.rating,
    required this.genres,
    required this.description,
    required this.director,
    required this.cast,
    this.posterUrl,
    this.backdropUrl,
    this.meshGradientColors,
  });

  factory MediaData.fromJson(Map<String, dynamic> json) {
    return MediaData(
      id: json['id'] as String,
      title: json['title'] as String,
      year: json['year'] as String,
      duration: json['duration'] as String,
      rating: json['rating'] as String,
      genres: List<String>.from(json['genres'] as List),
      description: json['description'] as String,
      director: json['director'] as String,
      cast: List<String>.from(json['cast'] as List),
      posterUrl: json['posterUrl'] as String?,
      backdropUrl: json['backdropUrl'] as String?,
      meshGradientColors: json['meshGradientColors'] != null
          ? List<String>.from(json['meshGradientColors'] as List)
          : null,
    );
  }
}
