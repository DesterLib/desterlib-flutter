import 'season.dart';

class TvShowDetails {
  final String id;
  final String mediaId;
  final String title;
  final String? description;
  final String? posterUrl;
  final String? backdropUrl;
  final DateTime? firstAirDate;
  final double? rating;
  final String? creator;
  final String? network;
  final List<String> genres;
  final List<String> cast;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<Season> seasons;
  final String baseUrl;

  TvShowDetails({
    required this.id,
    required this.mediaId,
    required this.title,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.firstAirDate,
    this.rating,
    this.creator,
    this.network,
    this.genres = const [],
    this.cast = const [],
    this.numberOfSeasons = 0,
    this.numberOfEpisodes = 0,
    this.seasons = const [],
    required this.baseUrl,
  });

  factory TvShowDetails.fromJson(Map<String, dynamic> json, String baseUrl) {
    return TvShowDetails(
      id: json['id'] ?? '',
      mediaId: json['mediaId'] ?? json['media']?['id'] ?? '',
      title: json['title'] ?? json['media']?['title'] ?? '',
      description: json['description'] ?? json['media']?['description'],
      posterUrl: json['posterUrl'] ?? json['media']?['posterUrl'],
      backdropUrl: json['backdropUrl'] ?? json['media']?['backdropUrl'],
      firstAirDate: json['firstAirDate'] != null
          ? DateTime.tryParse(json['firstAirDate'])
          : json['media']?['releaseDate'] != null
          ? DateTime.tryParse(json['media']['releaseDate'])
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : json['media']?['rating'] != null
          ? (json['media']['rating'] as num).toDouble()
          : null,
      creator: json['creator'],
      network: json['network'],
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      cast: (json['cast'] as List<dynamic>?)?.cast<String>() ?? [],
      numberOfSeasons: json['numberOfSeasons'] ?? 0,
      numberOfEpisodes: json['numberOfEpisodes'] ?? 0,
      seasons:
          (json['seasons'] as List<dynamic>?)
              ?.map(
                (e) => Season.fromJson(Map<String, dynamic>.from(e), baseUrl),
              )
              .toList() ??
          [],
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

  String get formattedRating {
    if (rating == null) return 'N/A';
    return rating!.toStringAsFixed(1);
  }

  String get formattedSeasons {
    if (numberOfSeasons == 1) return '1 Season';
    return '$numberOfSeasons Seasons';
  }
}
