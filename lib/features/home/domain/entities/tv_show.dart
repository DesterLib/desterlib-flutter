class TVShow {
  final String id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final String? firstAirDate;
  final double? rating;
  final List<String>? meshGradientColors;
  final DateTime? createdAt;

  const TVShow({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.firstAirDate,
    this.rating,
    this.meshGradientColors,
    this.createdAt,
  });
}
