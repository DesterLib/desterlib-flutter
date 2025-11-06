import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/core/providers/websocket_provider.dart';
import 'package:dester/core/services/websocket_service.dart';
import 'package:dester/shared/widgets/ui/scan_progress_bar.dart';
import '../widgets/settings_layout.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_item.dart';
import '../modals/add_library_modal.dart';
import '../modals/edit_library_modal.dart';
import '../modals/delete_library_modal.dart';

class ManageLibrariesScreen extends ConsumerWidget {
  const ManageLibrariesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final librariesAsync = ref.watch(actualLibrariesProvider);

    return AnimatedAppBarPage(
      title: 'Manage Libraries',
      maxWidthConstraint: 1220,
      actions: [
        IconButton(
          icon: Icon(PlatformIcons.add),
          color: AppColors.textPrimary,
          iconSize: 24,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          onPressed: () async {
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

          return _LibrariesList(libraries: libraries);
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

// Libraries list widget using DSettingsLayout
class _LibrariesList extends ConsumerWidget {
  final BuiltList<ModelLibrary> libraries;

  const _LibrariesList({required this.libraries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DSettingsLayout(
      groups: [
        DSettingsGroup(
          title: 'Libraries',
          items: libraries
              .map((library) => _buildLibraryItem(library, ref, context))
              .toList(),
        ),
      ],
    );
  }

  DSettingsItem _buildLibraryItem(
    ModelLibrary library,
    WidgetRef ref,
    BuildContext context,
  ) {
    final scanProgress = ref.watch(scanProgressProvider);
    final progress = scanProgress.getProgress(library.id);
    final isScanning = progress?.isScanning ?? false;

    return DSettingsItem(
      title: library.name,
      subtitle: _buildSubtitle(library, progress),
      icon: _getLibraryIcon(library.libraryType),
      progressBar: isScanning
          ? ScanProgressBar(progress: progress, height: 2)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isScanning) ...[
            CompactScanProgress(progress: progress!),
            const SizedBox(width: 12),
          ],
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: Colors.white.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () async {
              final result = await EditLibraryModal.show(
                context,
                libraryId: library.id,
              );
              if (result == true) {
                ref.invalidate(actualLibrariesProvider);
              }
            },
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(PlatformIcons.delete, size: 18),
            color: Colors.white.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () async {
              final result = await DeleteLibraryModal.show(
                context,
                libraryId: library.id,
              );
              if (result == true) {
                ref.invalidate(actualLibrariesProvider);
              }
            },
          ),
        ],
      ),
      onTap: () {
        // Future: Navigate to library details
      },
    );
  }

  String _buildSubtitle(ModelLibrary library, ScanProgressMessage? progress) {
    final parts = <String>[];

    // Add type
    parts.add(_getLibraryTypeDisplayName(library.libraryType));

    // Add path if available
    if (library.libraryPath != null) {
      parts.add(library.libraryPath!);
    }

    // Add scan progress message if scanning
    if (progress != null &&
        progress.isScanning &&
        progress.message.isNotEmpty) {
      parts.add(progress.message);
    }

    return parts.join(' • ');
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
