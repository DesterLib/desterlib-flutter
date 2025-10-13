import 'package:equatable/equatable.dart';

/// State for the video player
class VideoPlayerState extends Equatable {
  final String videoUrl;
  final String? title;
  final int? season;
  final int? episode;
  final String? episodeTitle;
  final bool isInitialized;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final double volume;
  final bool isMuted;
  final bool isFullscreen;

  const VideoPlayerState({
    required this.videoUrl,
    this.title,
    this.season,
    this.episode,
    this.episodeTitle,
    this.isInitialized = false,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 100.0,
    this.isMuted = false,
    this.isFullscreen = false,
  });

  VideoPlayerState copyWith({
    String? videoUrl,
    String? title,
    int? season,
    int? episode,
    String? episodeTitle,
    bool? isInitialized,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? volume,
    bool? isMuted,
    bool? isFullscreen,
  }) {
    return VideoPlayerState(
      videoUrl: videoUrl ?? this.videoUrl,
      title: title ?? this.title,
      season: season ?? this.season,
      episode: episode ?? this.episode,
      episodeTitle: episodeTitle ?? this.episodeTitle,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }

  String? get formattedTitle {
    if (title == null) return null;

    // Check if it's a TV show (has season and episode)
    if (season != null && episode != null) {
      final seasonEpisode = 'S${season}E$episode';
      if (episodeTitle != null && episodeTitle!.isNotEmpty) {
        return '$title | $seasonEpisode - $episodeTitle';
      }
      return '$title | $seasonEpisode';
    }

    // It's a movie, just return the title
    return title;
  }

  @override
  List<Object?> get props => [
    videoUrl,
    title,
    season,
    episode,
    episodeTitle,
    isInitialized,
    isPlaying,
    position,
    duration,
    volume,
    isMuted,
    isFullscreen,
  ];
}
