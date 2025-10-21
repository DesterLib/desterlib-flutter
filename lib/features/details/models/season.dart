import 'episode.dart';

class Season {
  final String id;
  final int seasonNumber;
  final String? name;
  final String? description;
  final String? posterUrl;
  final DateTime? airDate;
  final int episodeCount;
  final List<Episode> episodes;
  final String baseUrl;

  Season({
    required this.id,
    required this.seasonNumber,
    this.name,
    this.description,
    this.posterUrl,
    this.airDate,
    required this.episodeCount,
    this.episodes = const [],
    required this.baseUrl,
  });

  factory Season.fromJson(Map<String, dynamic> json, String baseUrl) {
    final seasonNumber = json['number'] ?? json['seasonNumber'] ?? 0;
    final episodes =
        (json['episodes'] as List<dynamic>?)
            ?.map(
              (e) => Episode.fromJson(Map<String, dynamic>.from(e), baseUrl),
            )
            .toList() ??
        [];

    return Season(
      id: json['id'] ?? '',
      seasonNumber: seasonNumber,
      name: json['name'] ?? 'Season $seasonNumber',
      description: json['description'] ?? json['overview'],
      posterUrl: json['posterUrl'] ?? json['posterPath'],
      airDate: json['airDate'] != null
          ? DateTime.tryParse(json['airDate'])
          : null,
      episodeCount: json['episodeCount'] ?? episodes.length,
      episodes: episodes,
      baseUrl: baseUrl,
    );
  }

  String get displayName => name ?? 'Season $seasonNumber';
}
