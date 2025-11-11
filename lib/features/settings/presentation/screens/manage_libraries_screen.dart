import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import 'package:dester/shared/widgets/ui/toast.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/shared/utils/error_parser.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/app/providers.dart';
import 'package:dester/core/providers/websocket_provider.dart';
import 'package:dester/shared/widgets/ui/scan_progress_bar.dart';
import 'package:dester/features/library/utils/library_helpers.dart';
import '../widgets/settings_layout.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_item.dart';
import '../modals/library_modals.dart';

class ManageLibrariesScreen extends ConsumerStatefulWidget {
  const ManageLibrariesScreen({super.key});

  @override
  ConsumerState<ManageLibrariesScreen> createState() =>
      _ManageLibrariesScreenState();
}

class _ManageLibrariesScreenState extends ConsumerState<ManageLibrariesScreen> {
  @override
  Widget build(BuildContext context) {
    final librariesAsync = ref.watch(actualLibrariesProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    // Listen for scan completion and show toast notifications
    ref.listen<ScanProgressState>(scanProgressProvider, (previous, next) {
      if (!mounted) return;

      // Check for newly completed or errored scans
      for (final entry in next.libraryProgress.entries) {
        final libraryId = entry.key;
        final progress = entry.value;
        final previousProgress = previous?.libraryProgress[libraryId];

        // Check if this scan just completed
        final justCompleted =
            progress.isComplete &&
            (previousProgress == null || !previousProgress.isComplete);

        if (justCompleted) {
          DToast.show(
            context,
            message: progress.message.isNotEmpty
                ? progress.message
                : 'Scan completed successfully',
            type: DToastType.success,
          );
        }

        // Check if this scan just errored
        final justErrored =
            progress.isError &&
            (previousProgress == null || !previousProgress.isError);

        if (justErrored) {
          DToast.show(
            context,
            message: progress.message.isNotEmpty
                ? progress.message
                : 'Scan failed',
            type: DToastType.error,
            duration: const Duration(seconds: 4),
          );
        }
      }
    });

    return AnimatedAppBarPage(
      title: 'Manage Libraries',
      useCompactHeight: isDesktop,
      maxWidthConstraint: 1220,
      leadingBuilder: (isScrolled) => DButton(
        icon: PlatformIcons.arrowBack,
        variant: isScrolled ? DButtonVariant.ghost : DButtonVariant.neutral,
        size: DButtonSize.sm,
        onTap: () => context.pop(),
      ),
      actions: [
        // Refresh button
        IconButton(
          icon: Icon(PlatformIcons.refresh),
          color: AppColors.textPrimary,
          iconSize: 24,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          tooltip: 'Refresh libraries',
          onPressed: () {
            ref.read(refreshLibrariesProvider)();
            DToast.show(
              context,
              message: 'Refreshing libraries...',
              type: DToastType.info,
              duration: const Duration(seconds: 2),
            );
          },
        ),
        const SizedBox(width: 4),
        // Add library button
        IconButton(
          icon: Icon(PlatformIcons.add),
          color: AppColors.textPrimary,
          iconSize: 24,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          tooltip: 'Add library',
          onPressed: () async {
            final result = await AddLibraryModal.show(context, ref);
            if (!mounted) return;

            if (result == true) {
              // Library was added successfully, refresh to show scan progress
              ref.read(refreshLibrariesProvider)();

              DToast.show(
                context,
                message: 'Library scan started...',
                type: DToastType.success,
                duration: const Duration(seconds: 2),
              );
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
            child: const Center(child: DLoadingIndicator()),
          ),
        ),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          onRetry: () => ref.read(refreshLibrariesProvider)(),
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
class _LibrariesList extends ConsumerStatefulWidget {
  final BuiltList<ModelLibrary> libraries;

  const _LibrariesList({required this.libraries});

  @override
  ConsumerState<_LibrariesList> createState() => _LibrariesListState();
}

class _LibrariesListState extends ConsumerState<_LibrariesList> {
  @override
  Widget build(BuildContext context) {
    // Listen for WebSocket connection changes and show toast
    ref.listen<ScanProgressState>(scanProgressProvider, (previous, next) {
      if (!mounted) return;

      // Show toast when connection state changes
      if (previous != null && previous.isConnected && !next.isConnected) {
        DToast.show(
          context,
          message: 'WebSocket disconnected - Scan progress updates unavailable',
          type: DToastType.error,
          duration: const Duration(seconds: 4),
        );
      } else if (previous != null &&
          !previous.isConnected &&
          next.isConnected) {
        DToast.show(
          context,
          message: 'WebSocket connected',
          type: DToastType.success,
          duration: const Duration(seconds: 2),
        );
      }
    });

    return DSettingsLayout(
      groups: [
        DSettingsGroup(
          title: 'Libraries',
          items: widget.libraries
              .map((library) => _buildLibraryItem(library, context))
              .toList(),
        ),
      ],
    );
  }

  DSettingsItem _buildLibraryItem(ModelLibrary library, BuildContext context) {
    final scanProgress = ref.watch(scanProgressProvider);
    final progress = scanProgress.getProgress(library.id);
    final isScanning = progress?.isScanning ?? false;

    // Build subtitle with batch progress info when scanning
    String subtitle = LibraryHelpers.getLibraryTypeDisplayName(
      library.libraryType,
    );
    if (library.libraryPath != null) {
      subtitle += ' • ${library.libraryPath}';
    }

    // Add batch progress info when scanning
    if (isScanning && progress != null) {
      final batchMatch = RegExp(
        r'Batch (\d+)/(\d+)',
      ).firstMatch(progress.message);
      if (batchMatch != null) {
        subtitle += ' • Batch ${batchMatch.group(1)}/${batchMatch.group(2)}';
      }
      if (progress.total > 0) {
        final percent = ((progress.current / progress.total) * 100).toInt();
        subtitle += ' • ${progress.current}/${progress.total} ($percent%)';
      }
      if (progress.batchItemComplete != null) {
        subtitle += ' • Latest: ${progress.batchItemComplete!.folderName}';
      }
    }

    return DSettingsItem(
      title: library.name,
      subtitle: subtitle,
      icon: LibraryHelpers.getLibraryIcon(library.libraryType),
      progressBar: isScanning
          ? ScanProgressBar(progress: progress, height: 2)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isScanning) ...[
            CompactScanProgress(progress: progress!),
            const SizedBox(width: 8),
          ],
          IconButton(
            icon: Icon(PlatformIcons.refresh, size: 18),
            color: Colors.white.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Rescan library',
            onPressed: isScanning
                ? null
                : () => _handleRescan(context, ref, library),
          ),
          const SizedBox(width: 2),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: Colors.white.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Edit library',
            onPressed: () async {
              final result = await EditLibraryModal.show(
                context,
                ref,
                libraryId: library.id,
              );
              if (result == true) {
                ref.read(refreshLibrariesProvider)();
              }
            },
          ),
          const SizedBox(width: 2),
          IconButton(
            icon: Icon(PlatformIcons.delete, size: 18),
            color: Colors.white.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Delete library',
            onPressed: () async {
              final result = await DeleteLibraryModal.show(
                context,
                ref,
                libraryId: library.id,
              );
              if (result == true) {
                ref.read(refreshLibrariesProvider)();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleRescan(
    BuildContext context,
    WidgetRef ref,
    ModelLibrary library,
  ) async {
    // Validate library has required data
    if (library.libraryPath == null) {
      DToast.show(
        context,
        message: 'Cannot rescan: Library path is missing',
        type: DToastType.error,
      );
      return;
    }

    try {
      final scanApi = ref.read(openapiClientProvider).getScanApi();

      // Map library type to scan media type
      ApiV1ScanPathPostRequestOptionsMediaTypeEnum? mediaType;
      switch (library.libraryType) {
        case ModelLibraryLibraryTypeEnum.MOVIE:
          mediaType = ApiV1ScanPathPostRequestOptionsMediaTypeEnum.movie;
          break;
        case ModelLibraryLibraryTypeEnum.TV_SHOW:
          mediaType = ApiV1ScanPathPostRequestOptionsMediaTypeEnum.tv;
          break;
        default:
          DToast.show(
            context,
            message: 'Cannot rescan: Unsupported library type',
            type: DToastType.error,
          );
          return;
      }

      // Build scan request with rescan=true
      final options = ApiV1ScanPathPostRequestOptionsBuilder()
        ..mediaType = mediaType
        ..rescan = true
        ..libraryName = library.name;

      final requestBuilder = ApiV1ScanPathPostRequestBuilder()
        ..path = library.libraryPath!
        ..options = options;

      // Trigger the rescan
      await scanApi.apiV1ScanPathPost(
        apiV1ScanPathPostRequest: requestBuilder.build(),
      );

      // Show success message
      if (context.mounted) {
        DToast.show(
          context,
          message: 'Rescanning "${library.name}"...',
          type: DToastType.success,
          duration: const Duration(seconds: 2),
        );
      }

      // Refresh libraries to show scanning state
      ref.read(refreshLibrariesProvider)();
    } catch (e) {
      // Show error message
      if (context.mounted) {
        final errorMessage = ErrorParser.parseScanError(e);
        DToast.show(
          context,
          message: errorMessage,
          type: DToastType.error,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }
}
