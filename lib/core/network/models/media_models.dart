/// Movie model
class MovieDto {
  final String id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? posterUrl;
  final String? backdropUrl;
  final String? nullPosterUrl;
  final String? nullBackdropUrl;
  final String? logoUrl;
  final DateTime? releaseDate;
  final double? rating;
  final List<GenreDto>? genres;
  final List<String>? meshGradientColors;
  final DateTime? createdAt;

  const MovieDto({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.posterUrl,
    this.backdropUrl,
    this.nullPosterUrl,
    this.nullBackdropUrl,
    this.logoUrl,
    this.releaseDate,
    this.rating,
    this.genres,
    this.meshGradientColors,
    this.createdAt,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) {
    return MovieDto(
      id: json['id'] as String,
      title: json['title'] as String,
      originalTitle: json['originalTitle'] as String?,
      overview: json['overview'] as String?,
      posterUrl: json['posterUrl'] as String?,
      backdropUrl: json['backdropUrl'] as String?,
      nullPosterUrl: json['nullPosterUrl'] as String?,
      nullBackdropUrl: json['nullBackdropUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      genres: json['genres'] != null
          ? (json['genres'] as List)
                .map((g) => GenreDto.fromJson(g as Map<String, dynamic>))
                .toList()
          : null,
      meshGradientColors: json['meshGradientColors'] != null
          ? List<String>.from(json['meshGradientColors'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}

/// TV Show model
class TvShowDto {
  final String id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? posterUrl;
  final String? backdropUrl;
  final String? nullPosterUrl;
  final String? nullBackdropUrl;
  final String? logoUrl;
  final DateTime? firstAirDate;
  final double? rating;
  final List<GenreDto>? genres;
  final List<String>? meshGradientColors;
  final DateTime? createdAt;

  const TvShowDto({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.posterUrl,
    this.backdropUrl,
    this.nullPosterUrl,
    this.nullBackdropUrl,
    this.logoUrl,
    this.firstAirDate,
    this.rating,
    this.genres,
    this.meshGradientColors,
    this.createdAt,
  });

  factory TvShowDto.fromJson(Map<String, dynamic> json) {
    return TvShowDto(
      id: json['id'] as String,
      title: json['title'] as String,
      originalTitle: json['originalTitle'] as String?,
      overview: json['overview'] as String?,
      posterUrl: json['posterUrl'] as String?,
      backdropUrl: json['backdropUrl'] as String?,
      nullPosterUrl: json['nullPosterUrl'] as String?,
      nullBackdropUrl: json['nullBackdropUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      firstAirDate: json['firstAirDate'] != null
          ? DateTime.parse(json['firstAirDate'])
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      genres: json['genres'] != null
          ? (json['genres'] as List)
                .map((g) => GenreDto.fromJson(g as Map<String, dynamic>))
                .toList()
          : null,
      meshGradientColors: json['meshGradientColors'] != null
          ? List<String>.from(json['meshGradientColors'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}

/// Genre model
class GenreDto {
  final String id;
  final String name;
  final String slug;

  const GenreDto({required this.id, required this.name, required this.slug});

  factory GenreDto.fromJson(Map<String, dynamic> json) {
    return GenreDto(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}

/// Search results
class SearchResultsDto {
  final List<MovieDto> movies;
  final List<TvShowDto> tvShows;

  const SearchResultsDto({required this.movies, required this.tvShows});

  factory SearchResultsDto.fromJson(Map<String, dynamic> json) {
    return SearchResultsDto(
      movies: json['movies'] != null
          ? (json['movies'] as List)
                .map((m) => MovieDto.fromJson(m as Map<String, dynamic>))
                .toList()
          : [],
      tvShows: json['tvShows'] != null
          ? (json['tvShows'] as List)
                .map((t) => TvShowDto.fromJson(t as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}
