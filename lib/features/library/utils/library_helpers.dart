import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/utils/platform_icons.dart';

/// Shared utility functions for library-related UI components
class LibraryHelpers {
  /// Returns the appropriate icon for a given library type
  static IconData getLibraryIcon(ModelLibraryLibraryTypeEnum? type) {
    switch (type) {
      case ModelLibraryLibraryTypeEnum.MOVIE:
        return PlatformIcons.movie;
      case ModelLibraryLibraryTypeEnum.TV_SHOW:
        return PlatformIcons.videoLibrary;
      case ModelLibraryLibraryTypeEnum.MUSIC:
        return PlatformIcons.playCircle;
      case ModelLibraryLibraryTypeEnum.COMIC:
        return PlatformIcons.libraryBooks;
      default:
        return PlatformIcons.videoLibrary;
    }
  }

  /// Returns the display name for a given library type
  static String getLibraryTypeDisplayName(ModelLibraryLibraryTypeEnum? type) {
    switch (type) {
      case ModelLibraryLibraryTypeEnum.MOVIE:
        return 'Movies';
      case ModelLibraryLibraryTypeEnum.TV_SHOW:
        return 'TV Shows';
      case ModelLibraryLibraryTypeEnum.MUSIC:
        return 'Music';
      case ModelLibraryLibraryTypeEnum.COMIC:
        return 'Comics';
      default:
        return 'Unknown';
    }
  }
}

/// Extension on ModelLibraryLibraryTypeEnum for convenient type conversions
extension LibraryTypeExtension on ModelLibraryLibraryTypeEnum {
  /// Converts ModelLibraryLibraryTypeEnum to ApiV1LibraryPutRequestLibraryTypeEnum
  ApiV1LibraryPutRequestLibraryTypeEnum toApiLibraryType() {
    switch (this) {
      case ModelLibraryLibraryTypeEnum.MOVIE:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MOVIE;
      case ModelLibraryLibraryTypeEnum.TV_SHOW:
        return ApiV1LibraryPutRequestLibraryTypeEnum.TV_SHOW;
      case ModelLibraryLibraryTypeEnum.MUSIC:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MUSIC;
      case ModelLibraryLibraryTypeEnum.COMIC:
        return ApiV1LibraryPutRequestLibraryTypeEnum.COMIC;
      default:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MOVIE;
    }
  }

  /// Returns the icon for this library type
  IconData get icon => LibraryHelpers.getLibraryIcon(this);

  /// Returns the display name for this library type
  String get displayName => LibraryHelpers.getLibraryTypeDisplayName(this);
}
