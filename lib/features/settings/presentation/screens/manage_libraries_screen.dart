import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';
import 'package:dester/app/theme/theme.dart';
import '../modals/add_library_modal.dart';
import '../modals/edit_library_modal.dart';
import '../modals/delete_library_modal.dart';

class ManageLibrariesScreen extends ConsumerWidget {
  const ManageLibrariesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final librariesAsync = ref.watch(actualLibrariesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return AnimatedAppBarPage(
      title: 'Manage Libraries',
      maxWidthConstraint: 1220,
      actions: [
        DButton(
          label: isMobile ? '' : 'Add Library',
          icon: PlatformIcons.add,
          variant: DButtonVariant.primary,
          size: DButtonSize.sm,
          onTap: () async {
            final result = await AddLibraryModal.show(context);
            if (result == true) {
              // Library was added successfully
              ref.invalidate(actualLibrariesProvider);
            }
          },
        ),
      ],
      child: librariesAsync.when(
        data: (libraries) {
          if (libraries.isEmpty) {
            return _EmptyState();
          }

          return _LibrariesGrid(libraries: libraries, isMobile: isMobile);
        },
        loading: () => Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          onRetry: () => ref.invalidate(actualLibrariesProvider),
        ),
      ),
    );
  }
}

// Empty state widget
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PlatformIcons.videoLibrary,
              size: 64,
              color: AppColors.textTertiary,
            ),
            AppSpacing.gapVerticalLG,
            Text(
              'No libraries found',
              style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
            ),
            AppSpacing.gapVerticalSM,
            Text(
              'Click the "Add Library" button to scan your media folders',
              style: AppTypography.bodyBase.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Error state widget
class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            AppSpacing.gapVerticalLG,
            Text('Error loading libraries', style: AppTypography.h3),
            AppSpacing.gapVerticalSM,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                error,
                style: AppTypography.bodyBase.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.gapVerticalLG,
            DButton(
              label: 'Retry',
              variant: DButtonVariant.secondary,
              size: DButtonSize.md,
              onTap: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

// Libraries grid/list widget
class _LibrariesGrid extends StatelessWidget {
  final BuiltList<ModelLibrary> libraries;
  final bool isMobile;

  const _LibrariesGrid({required this.libraries, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      // Mobile: List view
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: libraries.length,
        separatorBuilder: (context, index) => AppSpacing.gapVerticalMD,
        itemBuilder: (context, index) {
          return _LibraryCard(library: libraries[index]);
        },
      );
    }

    // Desktop/Tablet: Grid view
    final crossAxisCount = MediaQuery.of(context).size.width > 1024 ? 3 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.xl),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 1.5,
      ),
      itemCount: libraries.length,
      itemBuilder: (context, index) {
        return _LibraryCard(library: libraries[index]);
      },
    );
  }
}

// Library card widget
class _LibraryCard extends StatelessWidget {
  final ModelLibrary library;

  const _LibraryCard({required this.library});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLG,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and actions
          Padding(
            padding: AppSpacing.paddingLG,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundElevated,
                    borderRadius: AppRadius.radiusMD,
                  ),
                  child: Icon(
                    _getLibraryIcon(library.libraryType),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const Spacer(),
                _LibraryActions(library: library),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    library.name,
                    style: AppTypography.h4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapVerticalXS,
                  Text(
                    _getLibraryTypeDisplayName(library.libraryType),
                    style: AppTypography.bodySmall,
                  ),
                  if (library.description != null) ...[
                    AppSpacing.gapVerticalXS,
                    Expanded(
                      child: Text(
                        library.description!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Footer with path
          if (library.libraryPath != null)
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.lg),
                  bottomRight: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    PlatformIcons.folder,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 8),
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
    if (type == ModelLibraryLibraryTypeEnum.MOVIE) return 'Movies';
    if (type == ModelLibraryLibraryTypeEnum.TV_SHOW) return 'TV Shows';
    if (type == ModelLibraryLibraryTypeEnum.MUSIC) return 'Music';
    if (type == ModelLibraryLibraryTypeEnum.COMIC) return 'Comics';
    return 'Unknown';
  }
}

// Library actions widget
class _LibraryActions extends ConsumerWidget {
  final ModelLibrary library;

  const _LibraryActions({required this.library});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DButton(
          icon: Icons.edit,
          variant: DButtonVariant.ghost,
          size: DButtonSize.sm,
          onTap: () async {
            final result = await EditLibraryModal.show(
              context,
              libraryId: library.id,
            );
            if (result == true) {
              // Library was updated successfully
              ref.invalidate(actualLibrariesProvider);
            }
          },
        ),
        const SizedBox(width: 8),
        DButton(
          icon: PlatformIcons.delete,
          variant: DButtonVariant.ghost,
          size: DButtonSize.sm,
          onTap: () async {
            final result = await DeleteLibraryModal.show(
              context,
              libraryId: library.id,
            );
            if (result == true) {
              // Library was deleted successfully
              ref.invalidate(actualLibrariesProvider);
            }
          },
        ),
      ],
    );
  }
}
