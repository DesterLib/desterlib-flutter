class TVShow {
  final String id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? nullPosterUrl;
  final String? logoUrl;
  final String? overview;
  final String? firstAirDate;
  final double? rating;
  final List<String>? genres;
  final List<String>? meshGradientColors;
  final DateTime? createdAt;

  const TVShow({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.nullPosterUrl,
    this.logoUrl,
    this.overview,
    this.firstAirDate,
    this.rating,
    this.genres,
    this.meshGradientColors,
    this.createdAt,
  });
}
