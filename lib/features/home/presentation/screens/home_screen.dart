import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/scrollable_list.dart';
import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import 'package:dester/shared/widgets/layout/respect_sidebar.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/features/home/presentation/provider/media_provider.dart';
import 'package:dester/core/providers/websocket_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _refreshTimer;
  bool _needsRefresh = false;

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _scheduleRefresh() {
    if (!_needsRefresh) {
      _needsRefresh = true;
    }

    // Cancel existing timer
    _refreshTimer?.cancel();

    // Wait 5 seconds after last batch-complete before refreshing
    _refreshTimer = Timer(const Duration(seconds: 5), () {
      if (_needsRefresh && mounted) {
        ref.invalidate(moviesProvider);
        ref.invalidate(tvShowsProvider);
        _needsRefresh = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to scan progress and schedule refresh when batches complete
    ref.listen(scanProgressProvider, (previous, next) {
      // Only schedule refresh on batch-complete or scan-complete events
      for (final entry in next.libraryProgress.entries) {
        final progress = entry.value;
        final prevProgress = previous?.libraryProgress[entry.key];

        // Check if this is a NEW batch-complete event (not seen before)
        final isNewBatchComplete =
            progress.isBatchComplete &&
            (prevProgress == null || !prevProgress.isBatchComplete);

        if (isNewBatchComplete || progress.isComplete) {
          _scheduleRefresh();
        }
      }
    });

    final moviesAsync = ref.watch(moviesProvider);
    final tvShowsAsync = ref.watch(tvShowsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return AnimatedAppBarPage(
      title: 'Home',
      useCompactHeight: isDesktop,
      leading: const SizedBox.shrink(), // Prevent automatic back button
      child: moviesAsync.when(
        data: (movies) => tvShowsAsync.when(
          data: (tvShows) {
            // Check for empty state first
            if (movies.isEmpty && tvShows.isEmpty) {
              return const _EmptyState();
            }

            // Convert API data to DCardData format
            final movieCards = movies.map((movie) {
              final media = movie.media;
              return DCardData(
                title: media?.title ?? 'Unknown Title',
                year: media?.releaseDate?.year.toString() ?? '',
                imageUrl: media?.backdropUrl ?? media?.posterUrl,
                onTap: () {
                  if (movie.id != null) {
                    context.push('/media/${movie.id}?type=MOVIE');
                  }
                },
              );
            }).toList();

            final tvShowCards = tvShows.map((tvShow) {
              final media = tvShow.media;
              return DCardData(
                title: media?.title ?? 'Unknown Title',
                year: media?.releaseDate?.year.toString() ?? '',
                imageUrl: media?.backdropUrl ?? media?.posterUrl,
                onTap: () {
                  if (tvShow.id != null) {
                    context.push('/media/${tvShow.id}?type=TV_SHOW');
                  }
                },
              );
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                if (movieCards.isNotEmpty) ...[
                  DScrollableList(title: 'Movies', items: movieCards),
                  const SizedBox(height: 32),
                ],
                if (tvShowCards.isNotEmpty) ...[
                  DScrollableList(title: 'TV Shows', items: tvShowCards),
                  const SizedBox(height: 24),
                ],
              ],
            );
          },
          loading: () => const _LoadingState(),
          error: (error, stack) => _ErrorState(
            error: error.toString(),
            message: 'Failed to load TV shows',
          ),
        ),
        loading: () => const _LoadingState(),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          message: 'Failed to load movies',
        ),
      ),
    );
  }
}

// Empty state widget
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return RespectSidebar(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use available height from constraints, or calculate from screen if unbounded
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          final isDesktop = screenWidth > 900;
          final appBarHeight = isDesktop
              ? AppLayout.appBarHeightCompact
              : AppLayout.appBarHeightRegular;

          final availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : screenHeight - appBarHeight - AppLayout.extraLargePadding;

          return SizedBox(
            height: availableHeight,
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
                    'No media found',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.gapVerticalSM,
                  Text(
                    'Add a library to get started!',
                    style: AppTypography.bodyBase.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Loading state widget
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return RespectSidebar(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use available height from constraints, or calculate from screen if unbounded
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          final isDesktop = screenWidth > 900;
          final appBarHeight = isDesktop
              ? AppLayout.appBarHeightCompact
              : AppLayout.appBarHeightRegular;
          final isMobile = screenWidth <= 900;
          final bottomPadding = isMobile
              ? AppLayout.bottomNavBarHeight + AppLayout.extraLargePadding
              : AppLayout.extraLargePadding;

          final availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : screenHeight - appBarHeight - bottomPadding;

          return SizedBox(
            height: availableHeight,
            child: const Center(child: DLoadingIndicator()),
          );
        },
      ),
    );
  }
}

// Error state widget
class _ErrorState extends StatelessWidget {
  final String error;
  final String message;

  const _ErrorState({required this.error, required this.message});

  @override
  Widget build(BuildContext context) {
    return RespectSidebar(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use available height from constraints, or calculate from screen if unbounded
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          final isDesktop = screenWidth > 900;
          final appBarHeight = isDesktop
              ? AppLayout.appBarHeightCompact
              : AppLayout.appBarHeightRegular;
          final isMobile = screenWidth <= 900;
          final bottomPadding = isMobile
              ? AppLayout.bottomNavBarHeight + AppLayout.extraLargePadding
              : AppLayout.extraLargePadding;

          final availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : screenHeight - appBarHeight - bottomPadding;

          return SizedBox(
            height: availableHeight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  AppSpacing.gapVerticalLG,
                  Text(message, style: AppTypography.h3),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
