// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';

/// Common interface for media items that can be displayed in the hero section
sealed class MediaItem {
  final String id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? createdAt;

  MediaItem({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.createdAt,
  });
}

/// Movie as a MediaItem
class MovieMediaItem extends MediaItem {
  final Movie movie;

  MovieMediaItem({required this.movie})
    : super(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        backdropPath: movie.backdropPath,
        createdAt: movie.createdAt,
      );
}

/// TVShow as a MediaItem
class TVShowMediaItem extends MediaItem {
  final TVShow tvShow;
  final List<String>? meshGradientColors;

  TVShowMediaItem({required this.tvShow})
    : meshGradientColors = tvShow.meshGradientColors,
      super(
        id: tvShow.id,
        title: tvShow.title,
        posterPath: tvShow.posterPath,
        backdropPath: tvShow.backdropPath,
        createdAt: tvShow.createdAt,
      );
}
