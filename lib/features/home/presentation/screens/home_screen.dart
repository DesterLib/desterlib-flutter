import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/scrollable_list.dart';
import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/loading_screen.dart';
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
                if (movieCards.isEmpty && tvShowCards.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Text(
                        'No media found. Add a library to get started!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const DLoadingScreen(),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load TV shows',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () => const DLoadingScreen(),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Failed to load movies',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
