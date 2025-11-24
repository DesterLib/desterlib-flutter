// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/custom_app_bar.dart';

// Features
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'package:dester/features/home/presentation/controllers/home_controller.dart';
import 'package:dester/features/home/presentation/widgets/media_item_card.dart';
import 'package:dester/features/home/presentation/widgets/media_item_slider.dart';

import 'package:dester/features/home/presentation/widgets/hero.dart';

class HomeScreen extends StatefulWidget {
  final HomeController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    widget.controller.loadAll();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Combine movies and TV shows, sort by createdAt (most recent first), take top 5
    final allMediaItems = <MediaItem>[
      ...widget.controller.movies.map((movie) => MovieMediaItem(movie: movie)),
      ...widget.controller.tvShows.map(
        (tvShow) => TVShowMediaItem(tvShow: tvShow),
      ),
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
          onRefresh: () => widget.controller.loadAll(),
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
                        // Hero Section
                        HeroSection(mediaItems: recentMediaItems),
                        // Movies Section
                        _buildMoviesSection(),
                        AppConstants.spacingY(AppConstants.spacing24),
                        // TV Shows Section
                        _buildTVShowsSection(),
                      ],
                    ),
                  ),
                  CustomAppBar(
                    title: AppLocalization.homeTitle.tr(),
                    leftAligned: true,
                    animateBlur: true,
                  ),
                ],
              ),
              // Add bottom padding to account for floating bottom navigation bar
              // Height: pill height (60) + padding (8 top + 8 bottom) + safe area + margin
              SliverToBoxAdapter(
                child: SizedBox(
                  height:
                      60 + 8 + 8 + MediaQuery.of(context).padding.bottom + 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection() {
    return MediaItemSlider<Movie>(
      title: AppLocalization.homeMovies.tr(),
      items: widget.controller.movies,
      isLoading: widget.controller.isLoadingMovies,
      error: widget.controller.moviesError != null
          ? '${AppLocalization.homeError.tr()}: ${widget.controller.moviesError}'
          : null,
      emptyMessage: AppLocalization.homeNoMoviesAvailable.tr(),
      onRetry: () => widget.controller.loadMovies(),
      retryLabel: AppLocalization.homeRetry.tr(),
      itemBuilder: (context, movie, index) {
        return MediaItemCardVertical(
          number: index + 1,
          title: movie.title,
          mediaType: MediaType.movie,
          imageUrl: movie.posterPath,
          year: movie.releaseDate?.split('-').first,
        );
      },
    );
  }

  Widget _buildTVShowsSection() {
    return MediaItemSlider<TVShow>(
      title: AppLocalization.homeTvShows.tr(),
      items: widget.controller.tvShows,
      isLoading: widget.controller.isLoadingTVShows,
      error: widget.controller.tvShowsError != null
          ? '${AppLocalization.homeError.tr()}: ${widget.controller.tvShowsError}'
          : null,
      emptyMessage: AppLocalization.homeNoTVShowsAvailable.tr(),
      onRetry: () => widget.controller.loadTVShows(),
      retryLabel: AppLocalization.homeRetry.tr(),
      itemBuilder: (context, tvShow, index) {
        return MediaItemCardVertical(
          number: index + 1,
          title: tvShow.title,
          mediaType: MediaType.tvShow,
          imageUrl: tvShow.posterPath,
          year: tvShow.firstAirDate?.split('-').first,
        );
      },
    );
  }
}
