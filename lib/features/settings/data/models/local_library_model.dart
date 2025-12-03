enum ModelLibraryLibraryTypeEnum { MOVIE, TV_SHOW, MUSIC, COMIC }

class ModelLibrary {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? posterUrl;
  final String? backdropUrl;
  final bool? isLibrary;
  final String? libraryPath;
  final ModelLibraryLibraryTypeEnum? libraryType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? parentId;
  final int? mediaCount;

  ModelLibrary({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.isLibrary,
    this.libraryPath,
    this.libraryType,
    this.createdAt,
    this.updatedAt,
    this.parentId,
    this.mediaCount,
  });

  factory ModelLibrary.fromJson(Map<String, dynamic> json) {
    return ModelLibrary(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      posterUrl: json['posterUrl']?.toString(),
      backdropUrl: json['backdropUrl']?.toString(),
      isLibrary: json['isLibrary'] as bool?,
      libraryPath: json['libraryPath']?.toString() ?? json['path']?.toString(),
      libraryType: _parseEnum(json['libraryType']?.toString()),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      parentId: json['parentId']?.toString(),
      mediaCount: json['mediaCount'] is num
          ? (json['mediaCount'] as num).toInt()
          : null,
    );
  }

  static ModelLibraryLibraryTypeEnum? _parseEnum(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'MOVIE':
        return ModelLibraryLibraryTypeEnum.MOVIE;
      case 'TV_SHOW':
        return ModelLibraryLibraryTypeEnum.TV_SHOW;
      case 'TVSHOW':
        return ModelLibraryLibraryTypeEnum.TV_SHOW;
      case 'MUSIC':
        return ModelLibraryLibraryTypeEnum.MUSIC;
      case 'COMIC':
        return ModelLibraryLibraryTypeEnum.COMIC;
      default:
        return null;
    }
  }
}
