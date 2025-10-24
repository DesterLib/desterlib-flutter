class LibraryModel {
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

  const LibraryModel({
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

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      posterUrl: json['posterUrl'] as String?,
      backdropUrl: json['backdropUrl'] as String?,
      isLibrary: json['isLibrary'] as bool,
      libraryPath: json['libraryPath'] as String?,
      libraryType: json['libraryType'] != null
          ? LibraryType.fromString(json['libraryType'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      parentId: json['parentId'] as String?,
      mediaCount: json['mediaCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'isLibrary': isLibrary,
      'libraryPath': libraryPath,
      'libraryType': libraryType?.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'parentId': parentId,
      'mediaCount': mediaCount,
    };
  }

  LibraryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    bool? isLibrary,
    String? libraryPath,
    LibraryType? libraryType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentId,
    int? mediaCount,
  }) {
    return LibraryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      isLibrary: isLibrary ?? this.isLibrary,
      libraryPath: libraryPath ?? this.libraryPath,
      libraryType: libraryType ?? this.libraryType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentId: parentId ?? this.parentId,
      mediaCount: mediaCount ?? this.mediaCount,
    );
  }
}

enum LibraryType {
  movie('MOVIE'),
  tvShow('TV_SHOW'),
  music('MUSIC'),
  comic('COMIC');

  const LibraryType(this.value);
  final String value;

  static LibraryType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'MOVIE':
        return LibraryType.movie;
      case 'TV_SHOW':
        return LibraryType.tvShow;
      case 'MUSIC':
        return LibraryType.music;
      case 'COMIC':
        return LibraryType.comic;
      default:
        throw ArgumentError('Invalid library type: $value');
    }
  }

  String get displayName {
    switch (this) {
      case LibraryType.movie:
        return 'Movies';
      case LibraryType.tvShow:
        return 'TV Shows';
      case LibraryType.music:
        return 'Music';
      case LibraryType.comic:
        return 'Comics';
    }
  }
}

class LibraryUpdateRequest {
  final String id;
  final String? name;
  final String? description;
  final String? posterUrl;
  final String? backdropUrl;
  final String? libraryPath;
  final LibraryType? libraryType;

  const LibraryUpdateRequest({
    required this.id,
    this.name,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.libraryPath,
    this.libraryType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (posterUrl != null) 'posterUrl': posterUrl,
      if (backdropUrl != null) 'backdropUrl': backdropUrl,
      if (libraryPath != null) 'libraryPath': libraryPath,
      if (libraryType != null) 'libraryType': libraryType!.value,
    };
  }
}

class LibraryDeleteRequest {
  final String id;

  const LibraryDeleteRequest({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class LibraryFilters {
  final bool? isLibrary;
  final LibraryType? libraryType;

  const LibraryFilters({this.isLibrary, this.libraryType});

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (isLibrary != null) params['isLibrary'] = isLibrary.toString();
    if (libraryType != null) params['libraryType'] = libraryType!.value;
    return params;
  }
}
