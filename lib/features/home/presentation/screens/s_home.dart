// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_bottom_nav_space.dart';

// Features
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'package:dester/features/home/presentation/controllers/home_controller.dart';
import 'package:dester/features/home/presentation/widgets/media_item_card.dart';
import 'package:dester/features/home/presentation/widgets/media_item_slider.dart';

import 'package:dester/features/home/presentation/widgets/carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataAndPrefetch();
    });
  }

  Future<void> _loadDataAndPrefetch() async {
    final controller = ref.read(homeControllerProvider.notifier);
    final state = ref.read(homeControllerProvider);

    // Only load if initial load hasn't been done yet
    if (!state.hasInitiallyLoaded) {
      await controller.loadAll();
    }
    // Prefetch hero images after data is loaded
    if (mounted) {
      _prefetchHeroImages();
    }
  }

  /// Prefetch hero images (backdrop/poster + logo) for the top items
  void _prefetchHeroImages() {
    final state = ref.read(homeControllerProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Combine movies and TV shows, sort by createdAt (most recent first), take top 5
    final allMediaItems = <MediaItem>[
      ...state.movies.map((movie) => MovieMediaItem(movie: movie)),
      ...state.tvShows.map((tvShow) => TVShowMediaItem(tvShow: tvShow)),
    ];

    // Sort by createdAt (most recent first)
    allMediaItems.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });

    // Take top 5 items
    final topItems = allMediaItems.take(5).toList();

    // Prefetch images for each item
    for (final item in topItems) {
      // Prefetch backdrop/poster
      String? imageUrl;
      if (isMobile) {
        imageUrl = item.nullPosterUrl ?? item.posterPath ?? item.backdropPath;
      } else {
        imageUrl = item.backdropPath ?? item.nullPosterUrl ?? item.posterPath;
      }
      if (imageUrl != null) {
        precacheImage(CachedNetworkImageProvider(imageUrl), context).catchError(
          (_) {
            // Ignore prefetch errors
          },
        );
      }

      // Prefetch logo
      if (item.logoUrl != null) {
        precacheImage(
          CachedNetworkImageProvider(item.logoUrl!),
          context,
        ).catchError((_) {
          // Ignore prefetch errors
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    // Combine movies and TV shows, sort by createdAt (most recent first), take top 5
    final allMediaItems = <MediaItem>[
      ...state.movies.map((movie) => MovieMediaItem(movie: movie)),
      ...state.tvShows.map((tvShow) => TVShowMediaItem(tvShow: tvShow)),
    ];

    // Sort by createdAt (most recent first), null values go to the end
    allMediaItems.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });

    // Take the top 5 most recently added items
    final recentMediaItems = allMediaItems.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Allow RefreshIndicator to handle overscroll
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => controller.loadAll(force: true),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: <Widget>[
              // Small transparent sliver at top to allow RefreshIndicator overscroll detection
              SliverToBoxAdapter(child: SizedBox(height: 1)),
              SliverStack(
                children: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Carousel
                        if (recentMediaItems.isNotEmpty ||
                            state.isLoadingMovies ||
                            state.isLoadingTVShows)
                          HeroCarousel(mediaItems: recentMediaItems)
                        else
                          Container(
                            color: Colors.white.withValues(alpha: 0.2),
                            height: 600,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'No media found',
                                style: AppTypography.headlineMedium(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ),
                        // Movies Section
                        _buildMoviesSection(),
                        AppConstants.spacingY(AppConstants.spacing24),
                        // TV Shows Section
                        _buildTVShowsSection(),
                      ],
                    ),
                  ),
                  DAppBar(
                    title: AppLocalization.homeTitle.tr(),
                    leftAligned: true,
                    animateBlur: true,
                  ),
                ],
              ),
              // Add bottom padding to account for floating bottom navigation bar
              SliverToBoxAdapter(
                child: DBottomNavSpace(
                  child: AppConstants.spacingY(AppConstants.spacing16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection() {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    // Use only actual movies from the controller
    final allMovies = state.movies;

    return MediaItemSlider<Movie>(
      title: AppLocalization.homeMovies.tr(),
      items: allMovies,
      isLoading: state.isLoadingMovies,
      error: state.moviesError != null
          ? '${AppLocalization.homeError.tr()}: ${state.moviesError}'
          : null,
      emptyMessage: AppLocalization.homeNoMoviesAvailable.tr(),
      onRetry: () => controller.loadMovies(),
      retryLabel: AppLocalization.homeRetry.tr(),
      itemBuilder: (context, movie, index) {
        return MediaItemCardVertical(
          number: index + 1,
          title: movie.title,
          mediaType: MediaType.movie,
          imageUrl: movie.backdropPath,
          year: movie.releaseDate?.split('-').first,
        );
      },
    );
  }

  Widget _buildTVShowsSection() {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    // Use only actual TV shows from the controller
    final allTVShows = state.tvShows;

    return MediaItemSlider<TVShow>(
      title: AppLocalization.homeTvShows.tr(),
      items: allTVShows,
      isLoading: state.isLoadingTVShows,
      error: state.tvShowsError != null
          ? '${AppLocalization.homeError.tr()}: ${state.tvShowsError}'
          : null,
      emptyMessage: AppLocalization.homeNoTVShowsAvailable.tr(),
      onRetry: () => controller.loadTVShows(),
      retryLabel: AppLocalization.homeRetry.tr(),
      itemBuilder: (context, tvShow, index) {
        return MediaItemCardVertical(
          number: index + 1,
          title: tvShow.title,
          mediaType: MediaType.tvShow,
          imageUrl: tvShow.backdropPath,
          year: tvShow.firstAirDate?.split('-').first,
        );
      },
    );
  }
}
