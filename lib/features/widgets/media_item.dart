enum MediaType { movie, show }

class MediaItem {
  const MediaItem({
    required this.id,
    required this.title,
    required this.poster,
    this.type = MediaType.movie,
  });

  final String id;
  final String title;
  final String poster;
  final MediaType type;
}
