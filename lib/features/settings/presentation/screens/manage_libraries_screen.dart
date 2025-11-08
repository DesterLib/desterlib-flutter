import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:dester/core/services/websocket_service.dart';
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
      maxWidthConstraint: 1220,
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

              if (!mounted) return;
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
      subtitle: _buildSubtitle(library, progress, context),
      icon: LibraryHelpers.getLibraryIcon(library.libraryType),
      progressBar: isScanning
          ? ScanProgressBar(progress: progress, height: 2)
          : null,
      trailing: LayoutBuilder(
        builder: (context, constraints) {
          // On very small screens, show compact actions
          final isVerySmall = MediaQuery.of(context).size.width < 400;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isScanning && !isVerySmall) ...[
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
          );
        },
      ),
    );
  }

  String _buildSubtitle(
    ModelLibrary library,
    ScanProgressMessage? progress,
    BuildContext context,
  ) {
    final parts = <String>[];

    // Add type
    parts.add(LibraryHelpers.getLibraryTypeDisplayName(library.libraryType));

    // Add path if available (truncate if too long on mobile)
    if (library.libraryPath != null) {
      String path = library.libraryPath!;

      // On smaller screens, show shortened path
      if (MediaQuery.of(context).size.width < 600 && path.length > 40) {
        // Show just the last part of the path
        final pathParts = path.split('/');
        if (pathParts.length > 2) {
          path = '.../${pathParts[pathParts.length - 2]}/${pathParts.last}';
        }
      }

      parts.add(path);
    }

    // Add scan progress message if scanning
    if (progress != null &&
        progress.isScanning &&
        progress.message.isNotEmpty) {
      parts.add(progress.message);
    }

    return parts.join(' • ');
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
