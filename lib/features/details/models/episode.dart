class Episode {
  final String id; // Episode file ID - used for streaming
  final String title;
  final int episodeNumber;
  final int seasonNumber;
  final String? description;
  final String? stillUrl;
  final int? duration;
  final DateTime? airDate;
  final String? filePath;
  final String tvShowId;
  final String streamUrl; // Stream URL from API
  final String baseUrl;

  Episode({
    required this.id,
    required this.title,
    required this.episodeNumber,
    required this.seasonNumber,
    this.description,
    this.stillUrl,
    this.duration,
    this.airDate,
    this.filePath,
    required this.tvShowId,
    required this.streamUrl,
    required this.baseUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json, String baseUrl) {
    final streamUrl = json['streamUrl'] != null
        ? '$baseUrl${json['streamUrl']}'
        : '$baseUrl/api/v1/stream/${json['id']}';

    final episodeNumber = json['number'] ?? json['episodeNumber'] ?? 0;

    return Episode(
      // Episode file ID from the API response
      id: json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? 'Episode $episodeNumber',
      episodeNumber: episodeNumber,
      seasonNumber: json['seasonNumber'] ?? 0,
      description: json['description'] ?? json['overview'],
      stillUrl: json['stillPath'] ?? json['stillUrl'],
      duration: json['duration'] ?? json['runtime'],
      airDate: json['airDate'] != null
          ? DateTime.tryParse(json['airDate'])
          : null,
      filePath: json['filePath'],
      tvShowId: json['tvShowId'] ?? json['seasonId'] ?? '',
      streamUrl: streamUrl,
      baseUrl: baseUrl,
    );
  }

  String? get fullStillUrl => stillUrl != null && stillUrl!.startsWith('http')
      ? stillUrl
      : stillUrl != null
      ? '$baseUrl$stillUrl'
      : null;
}
