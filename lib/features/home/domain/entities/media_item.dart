// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';

/// Common interface for media items that can be displayed in the hero section
sealed class MediaItem {
  final String id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? plainPosterUrl;
  final String? logoUrl;
  final DateTime? createdAt;

  MediaItem({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.plainPosterUrl,
    this.logoUrl,
    this.createdAt,
  });
}

/// Movie as a MediaItem
class MovieMediaItem extends MediaItem {
  final Movie movie;
  final List<String>? meshGradientColors;

  MovieMediaItem({required this.movie})
    : meshGradientColors = movie.meshGradientColors,
      super(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        backdropPath: movie.backdropPath,
        plainPosterUrl: movie.plainPosterUrl,
        logoUrl: movie.logoUrl,
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
        plainPosterUrl: tvShow.plainPosterUrl,
        logoUrl: tvShow.logoUrl,
        createdAt: tvShow.createdAt,
      );
}
