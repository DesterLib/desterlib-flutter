import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';

class DeleteLibraryModal {
  static Future<bool?> show(BuildContext context, {required String libraryId}) {
    return showSettingsModal<bool>(
      context: context,
      title: 'Delete Library',
      builder: (context) => _DeleteLibraryModalContent(libraryId: libraryId),
    );
  }
}

class _DeleteLibraryModalContent extends ConsumerStatefulWidget {
  final String libraryId;

  const _DeleteLibraryModalContent({required this.libraryId});

  @override
  ConsumerState<_DeleteLibraryModalContent> createState() =>
      _DeleteLibraryModalContentState();
}

class _DeleteLibraryModalContentState
    extends ConsumerState<_DeleteLibraryModalContent> {
  bool _isLoading = true;
  bool _isDeleting = false;
  String? _errorMessage;
  ModelLibrary? _library;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    try {
      final libraries = await ref.read(actualLibrariesProvider.future);
      final library = libraries.firstWhere(
        (lib) => lib.id == widget.libraryId,
        orElse: () => throw Exception('Library not found'),
      );

      if (mounted) {
        setState(() {
          _library = library;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load library: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleDelete() async {
    setState(() {
      _isDeleting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(libraryManagementProvider.notifier)
          .deleteLibrary(widget.libraryId);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to delete library: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_library == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsModalBanner(
            message: _errorMessage ?? 'Library not found',
            type: SettingsModalBannerType.error,
          ),
          AppSpacing.gapVerticalLG,
          DButton(
            label: 'Close',
            variant: DButtonVariant.secondary,
            size: DButtonSize.md,
            onTap: () => Navigator.of(context).pop(false),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Library info card
        _LibraryInfoCard(library: _library!),
        AppSpacing.gapVerticalLG,

        // Confirmation message
        Text(
          'Are you sure you want to delete this library?',
          style: AppTypography.h4,
        ),
        AppSpacing.gapVerticalMD,

        Text(
          'This will also delete all media entries that belong exclusively to this library.',
          style: AppTypography.bodyBase.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapVerticalLG,

        // Warning banner
        SettingsModalBanner(
          message:
              'Warning: This action cannot be undone. Media files on disk will not be deleted.',
          type: SettingsModalBannerType.warning,
          icon: Icons.warning_amber_outlined,
        ),

        // Error banner
        if (_errorMessage != null)
          SettingsModalBanner(
            message: _errorMessage!,
            type: SettingsModalBannerType.error,
          ),

        AppSpacing.gapVerticalLG,

        // Actions
        SettingsModalActions(
          actions: [
            DButton(
              label: 'Cancel',
              variant: DButtonVariant.ghost,
              size: DButtonSize.md,
              onTap: _isDeleting
                  ? null
                  : () => Navigator.of(context).pop(false),
            ),
            DButton(
              label: _isDeleting ? 'Deleting...' : 'Delete Library',
              variant: DButtonVariant.danger,
              size: DButtonSize.md,
              onTap: _isDeleting ? null : _handleDelete,
            ),
          ],
        ),
      ],
    );
  }
}

// Library info card widget
class _LibraryInfoCard extends StatelessWidget {
  final ModelLibrary library;

  const _LibraryInfoCard({required this.library});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMD,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: AppRadius.radiusSM,
            ),
            child: Icon(
              _getLibraryIcon(library.libraryType),
              color: AppColors.primary,
              size: 24,
            ),
          ),
          AppSpacing.gapHorizontalMD,

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(library.name, style: AppTypography.h4),
                AppSpacing.gapVerticalXS,
                Text(
                  _getLibraryTypeDisplayName(library.libraryType),
                  style: AppTypography.bodySmall,
                ),
                if (library.libraryPath != null) ...[
                  AppSpacing.gapVerticalXS,
                  Row(
                    children: [
                      Icon(
                        PlatformIcons.folder,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          library.libraryPath!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLibraryIcon(ModelLibraryLibraryTypeEnum? type) {
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

  String _getLibraryTypeDisplayName(ModelLibraryLibraryTypeEnum? type) {
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
