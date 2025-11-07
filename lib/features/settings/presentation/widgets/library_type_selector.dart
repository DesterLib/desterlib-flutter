import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/ui/segmented_control.dart';
import 'package:dester/shared/utils/platform_icons.dart';

/// Shared widget for selecting library type in modals
/// Handles both add (using ApiV1ScanPathPostRequestOptionsMediaTypeEnum)
/// and edit (using ModelLibraryLibraryTypeEnum) scenarios
class LibraryTypeSelector {
  /// Build segmented control for Add Library modal
  static Widget forAddLibrary({
    required ApiV1ScanPathPostRequestOptionsMediaTypeEnum? currentType,
    required ValueChanged<ApiV1ScanPathPostRequestOptionsMediaTypeEnum?>
    onChanged,
  }) {
    return DSegmentedControl<ApiV1ScanPathPostRequestOptionsMediaTypeEnum>(
      value: currentType,
      options: [
        SegmentedOption(
          value: ApiV1ScanPathPostRequestOptionsMediaTypeEnum.movie,
          label: 'Movies',
          icon: PlatformIcons.movie,
        ),
        SegmentedOption(
          value: ApiV1ScanPathPostRequestOptionsMediaTypeEnum.tv,
          label: 'TV Shows',
          icon: PlatformIcons.videoLibrary,
        ),
      ],
      onChanged: onChanged,
    );
  }

  /// Build segmented control for Edit Library modal
  static Widget forEditLibrary({
    required ModelLibraryLibraryTypeEnum? currentType,
    required ValueChanged<ModelLibraryLibraryTypeEnum?> onChanged,
  }) {
    return DSegmentedControl<ModelLibraryLibraryTypeEnum>(
      value: currentType,
      options: [
        SegmentedOption(
          value: ModelLibraryLibraryTypeEnum.MOVIE,
          label: 'Movies',
          icon: PlatformIcons.movie,
        ),
        SegmentedOption(
          value: ModelLibraryLibraryTypeEnum.TV_SHOW,
          label: 'TV Shows',
          icon: PlatformIcons.videoLibrary,
        ),
      ],
      onChanged: onChanged,
    );
  }
}
