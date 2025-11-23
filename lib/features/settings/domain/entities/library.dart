/// Library entity representing a media library
class Library {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? posterUrl;
  final String? backdropUrl;
  final bool isLibrary;
  final String? libraryPath;
  final LibraryType? libraryType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? parentId;
  final int? mediaCount;

  const Library({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    required this.isLibrary,
    this.libraryPath,
    this.libraryType,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
    this.mediaCount,
  });
}

/// Library type enum
enum LibraryType {
  movie,
  tvShow,
  music,
  comic;

  String get displayName {
    switch (this) {
      case LibraryType.movie:
        return 'Movie';
      case LibraryType.tvShow:
        return 'TV Show';
      case LibraryType.music:
        return 'Music';
      case LibraryType.comic:
        return 'Comic';
    }
  }
}
