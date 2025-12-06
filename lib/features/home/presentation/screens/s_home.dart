// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/utils/color_extractor.dart';
import 'package:dester/core/widgets/d_primary_app_bar.dart';
import 'package:dester/core/widgets/d_bottom_nav_space.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_sidebar.dart';
import 'package:dester/core/widgets/d_scaffold.dart';
import 'package:dester/core/widgets/d_loading_wrapper.dart';
import 'package:dester/core/widgets/d_spinner.dart';
import 'package:dester/core/widgets/d_scrollview_slider.dart';
import 'package:dester/core/widgets/d_media_card.dart';

// Features
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:dester/features/home/presentation/controllers/home_controller.dart';

import 'package:dester/features/home/presentation/widgets/carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasPrefetched = false;

  @override
  void initState() {
    super.initState();
    // Data loading is now handled by HomeController based on connection status
  }

  /// Prefetch hero images (backdrop/poster + logo) and colors for the top items
  void _prefetchHeroImages() async {
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

    // Prefetch images and colors for each item
    for (final item in topItems) {
      // Determine which image to use for both caching and color extraction
      // Only use null images (without text overlays)
      String? imageUrl;
      if (isMobile) {
        imageUrl = item.nullPosterUrl;
      } else {
        imageUrl = item.nullBackdropUrl ?? item.nullPosterUrl;
      }

      if (imageUrl != null) {
        // Prefetch image
        precacheImage(CachedNetworkImageProvider(imageUrl), context).catchError(
          (_) {
            // Ignore prefetch errors
          },
        );

        // Prefetch color extraction (async, fire and forget)
        // This ensures colors are ready when the hero loads
        ColorExtractor.extractColorsFromUrl(imageUrl).catchError((_) {
          // Ignore color extraction errors
          return null;
        });
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

    // Listen for when data is loaded, then prefetch images (only once)
    // ref.listen must be called during build
    if (!_hasPrefetched && state.hasInitiallyLoaded) {
      _hasPrefetched = true;
      // Prefetch images after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _prefetchHeroImages();
        }
      });
    }

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
              SliverStack(
                children: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Carousel (always shown, handles empty state internally)
                        HeroCarousel(mediaItems: recentMediaItems),
                        AppConstants.spacingY(AppConstants.spacing24),
                        // Movies Section
                        _buildMoviesSection(),
                        AppConstants.spacingY(AppConstants.spacing24),
                        // TV Shows Section
                        _buildTVShowsSection(),
                      ],
                    ),
                  ),
                  DPrimaryAppBar(title: AppLocalization.homeTitle.tr()),
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
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);
    final sidebarTotalWidth = useDesktopLayout ? DSidebar.getTotalWidth() : 0.0;
    final allMovies = state.movies;
    final sliderHeight = 280.0;
    final padding = EdgeInsets.only(
      left: AppConstants.spacing16 + sidebarTotalWidth,
      right: AppConstants.spacing16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSidebarSpace(
          child: Padding(
            padding: AppConstants.padding(AppConstants.spacing16),
            child: Text(
              AppLocalization.homeMovies.tr(),
              style: AppTypography.headlineLarge(),
            ),
          ),
        ),
        DLoadingWrapper(
          isLoading: state.isLoadingMovies,
          loader: SizedBox(
            height: sliderHeight,
            child: const Center(child: DSpinner()),
          ),
          child: state.moviesError != null
              ? SizedBox(
                  height: sliderHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${AppLocalization.homeError.tr()}: ${state.moviesError}',
                          style: AppTypography.bodyMedium(color: Colors.red),
                        ),
                        AppConstants.spacingY(AppConstants.spacing8),
                        ElevatedButton(
                          onPressed: () => controller.loadMovies(),
                          child: Text(AppLocalization.homeRetry.tr()),
                        ),
                      ],
                    ),
                  ),
                )
              : allMovies.isEmpty
              ? DSidebarSpace(
                  child: SizedBox(
                    height: sliderHeight,
                    child: Center(
                      child: Text(AppLocalization.homeNoMoviesAvailable.tr()),
                    ),
                  ),
                )
              : SizedBox(
                  height: sliderHeight,
                  child: DScrollViewSlider(
                    showNavigationButtons: true,
                    builder: (context, scrollController) {
                      return ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: padding,
                        itemCount: allMovies.length,
                        itemBuilder: (context, index) {
                          final movie = allMovies[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == allMovies.length - 1
                                  ? 0
                                  : AppConstants.spacing12,
                            ),
                            child: DMediaItemCardVertical(
                              number: index + 1,
                              title: movie.title,
                              mediaType: DMediaType.movie,
                              imageUrl: movie.backdropPath,
                              year: movie.releaseDate?.split('-').first,
                              onTap: () {
                                context.push(
                                  '/media/${movie.id}?type=movie&title=${Uri.encodeComponent(movie.title)}',
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTVShowsSection() {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);
    final sidebarTotalWidth = useDesktopLayout ? DSidebar.getTotalWidth() : 0.0;
    final allTVShows = state.tvShows;
    final sliderHeight = 280.0;
    final padding = EdgeInsets.only(
      left: AppConstants.spacing16 + sidebarTotalWidth,
      right: AppConstants.spacing16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSidebarSpace(
          child: Padding(
            padding: AppConstants.padding(AppConstants.spacing16),
            child: Text(
              AppLocalization.homeTvShows.tr(),
              style: AppTypography.headlineLarge(),
            ),
          ),
        ),
        DLoadingWrapper(
          isLoading: state.isLoadingTVShows,
          loader: SizedBox(
            height: sliderHeight,
            child: const Center(child: DSpinner()),
          ),
          child: state.tvShowsError != null
              ? SizedBox(
                  height: sliderHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${AppLocalization.homeError.tr()}: ${state.tvShowsError}',
                          style: AppTypography.bodyMedium(color: Colors.red),
                        ),
                        AppConstants.spacingY(AppConstants.spacing8),
                        ElevatedButton(
                          onPressed: () => controller.loadTVShows(),
                          child: Text(AppLocalization.homeRetry.tr()),
                        ),
                      ],
                    ),
                  ),
                )
              : allTVShows.isEmpty
              ? DSidebarSpace(
                  child: SizedBox(
                    height: sliderHeight,
                    child: Center(
                      child: Text(AppLocalization.homeNoTVShowsAvailable.tr()),
                    ),
                  ),
                )
              : SizedBox(
                  height: sliderHeight,
                  child: DScrollViewSlider(
                    showNavigationButtons: true,
                    builder: (context, scrollController) {
                      return ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: padding,
                        itemCount: allTVShows.length,
                        itemBuilder: (context, index) {
                          final tvShow = allTVShows[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == allTVShows.length - 1
                                  ? 0
                                  : AppConstants.spacing12,
                            ),
                            child: DMediaItemCardVertical(
                              number: index + 1,
                              title: tvShow.title,
                              mediaType: DMediaType.tvShow,
                              imageUrl: tvShow.backdropPath,
                              year: tvShow.firstAirDate?.split('-').first,
                              onTap: () {
                                context.push(
                                  '/media/${tvShow.id}?type=tv&title=${Uri.encodeComponent(tvShow.title)}',
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
