class Movie {
  final String id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? plainPosterUrl;
  final String? logoUrl;
  final String? overview;
  final String? releaseDate;
  final double? rating;
  final List<String>? meshGradientColors;
  final DateTime? createdAt;

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.plainPosterUrl,
    this.logoUrl,
    this.overview,
    this.releaseDate,
    this.rating,
    this.meshGradientColors,
    this.createdAt,
  });
}
