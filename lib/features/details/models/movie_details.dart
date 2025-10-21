class MovieDetails {
  final String id; // Media item/file ID - used for streaming
  final String mediaId; // TMDB media reference ID
  final String title;
  final String? description;
  final String? posterUrl;
  final String? backdropUrl;
  final DateTime? releaseDate;
  final double? rating;
  final int? duration;
  final String? trailerUrl;
  final List<String> genres;
  final List<String> cast;
  final String? director;
  final String? filePath;
  final String streamUrl; // Stream URL from API
  final String baseUrl;

  MovieDetails({
    required this.id,
    required this.mediaId,
    required this.title,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.releaseDate,
    this.rating,
    this.duration,
    this.trailerUrl,
    this.genres = const [],
    this.cast = const [],
    this.director,
    this.filePath,
    required this.streamUrl,
    required this.baseUrl,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json, String baseUrl) {
    final streamUrl = json['streamUrl'] != null
        ? '$baseUrl${json['streamUrl']}'
        : '$baseUrl/api/v1/stream/${json['id']}';

    return MovieDetails(
      // Media item/file ID from the movie record
      id: json['id'] ?? '',
      // TMDB media reference ID
      mediaId: json['mediaId'] ?? json['media']?['id'] ?? '',
      title: json['title'] ?? json['media']?['title'] ?? '',
      description: json['description'] ?? json['media']?['description'],
      posterUrl: json['posterUrl'] ?? json['media']?['posterUrl'],
      backdropUrl: json['backdropUrl'] ?? json['media']?['backdropUrl'],
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'])
          : json['media']?['releaseDate'] != null
          ? DateTime.tryParse(json['media']['releaseDate'])
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : json['media']?['rating'] != null
          ? (json['media']['rating'] as num).toDouble()
          : null,
      duration: json['duration'],
      trailerUrl: json['trailerUrl'],
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      cast: (json['cast'] as List<dynamic>?)?.cast<String>() ?? [],
      director: json['director'],
      filePath: json['filePath'],
      streamUrl: streamUrl,
      baseUrl: baseUrl,
    );
  }

  String? get fullPosterUrl =>
      posterUrl != null && posterUrl!.startsWith('http')
      ? posterUrl
      : posterUrl != null
      ? '$baseUrl$posterUrl'
      : null;

  String? get fullBackdropUrl =>
      backdropUrl != null && backdropUrl!.startsWith('http')
      ? backdropUrl
      : backdropUrl != null
      ? '$baseUrl$backdropUrl'
      : null;

  String get formattedDuration {
    if (duration == null) return 'N/A';
    final hours = duration! ~/ 60;
    final minutes = duration! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedRating {
    if (rating == null) return 'N/A';
    return rating!.toStringAsFixed(1);
  }
}
