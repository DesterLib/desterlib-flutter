// External packages
import 'package:openapi/openapi.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';


/// Mapper for converting between API models and domain entities
class LibraryMapper {
  /// Convert API ModelLibrary to domain Library entity
  static Library fromApiModel(ModelLibrary model) {
    return Library(
      id: model.id,
      name: model.name,
      slug: model.slug,
      description: model.description,
      posterUrl: model.posterUrl,
      backdropUrl: model.backdropUrl,
      isLibrary: model.isLibrary,
      libraryPath: model.libraryPath,
      libraryType: _mapLibraryType(model.libraryType),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      parentId: model.parentId,
      mediaCount: model.mediaCount?.toInt(),
    );
  }

  /// Convert domain LibraryType to API enum
  static String? toApiLibraryType(LibraryType? type) {
    if (type == null) return null;
    switch (type) {
      case LibraryType.movie:
        return 'MOVIE';
      case LibraryType.tvShow:
        return 'TV_SHOW';
      case LibraryType.music:
        return 'MUSIC';
      case LibraryType.comic:
        return 'COMIC';
    }
  }

  /// Convert API enum to domain LibraryType
  static LibraryType? _mapLibraryType(ModelLibraryLibraryTypeEnum? type) {
    if (type == null) return null;
    // Compare enum values directly
    if (type == ModelLibraryLibraryTypeEnum.MOVIE) {
      return LibraryType.movie;
    } else if (type == ModelLibraryLibraryTypeEnum.TV_SHOW) {
      return LibraryType.tvShow;
    } else if (type == ModelLibraryLibraryTypeEnum.MUSIC) {
      return LibraryType.music;
    } else if (type == ModelLibraryLibraryTypeEnum.COMIC) {
      return LibraryType.comic;
    }
    return null;
  }
}
