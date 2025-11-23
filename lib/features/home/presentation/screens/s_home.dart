// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/custom_app_bar.dart';
import 'package:dester/core/widgets/mesh_gradient.dart';

// Features
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:dester/features/home/presentation/controllers/home_controller.dart';
import 'package:dester/features/home/presentation/widgets/movie_card.dart';
import 'package:dester/features/home/presentation/widgets/tv_show_card.dart';

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

    // Get mesh gradient colors from the first TV show in recent items
    final firstTVShowItem = recentMediaItems
        .whereType<TVShowMediaItem>()
        .firstOrNull;
    final meshColors = firstTVShowItem?.meshGradientColors ?? [];
    final hasValidMeshColors = meshColors.length == 4;

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
                        // Hero Carousel with recently added media
                        // Pass mesh gradient colors to blend with image
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            if (hasValidMeshColors)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeIn,
                                  builder: (context, opacity, child) {
                                    return Opacity(
                                      opacity: opacity,
                                      child: MeshGradient(
                                        colors: meshColors,
                                        height: 1200,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            HeroSection(mediaItems: recentMediaItems),
                          ],
                        ),
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
    return Padding(
      padding: AppConstants.padding(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalization.homeMovies.tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          AppConstants.spacingY(AppConstants.spacing16),
          if (widget.controller.isLoadingMovies)
            const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.controller.moviesError != null)
            SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppLocalization.homeError.tr()}: ${widget.controller.moviesError}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    AppConstants.spacingY(AppConstants.spacing8),
                    ElevatedButton(
                      onPressed: () => widget.controller.loadMovies(),
                      child: Text(AppLocalization.homeRetry.tr()),
                    ),
                  ],
                ),
              ),
            )
          else if (widget.controller.movies.isEmpty)
            SizedBox(
              height: 280,
              child: Center(
                child: Text(AppLocalization.homeNoMoviesAvailable.tr()),
              ),
            )
          else
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.controller.movies.length,
                itemBuilder: (context, index) {
                  final movie = widget.controller.movies[index];
                  return Padding(
                    padding: AppConstants.paddingOnly(
                      right: index == widget.controller.movies.length - 1
                          ? AppConstants.spacing0
                          : AppConstants.spacing12,
                    ),
                    child: MovieCard(movie: movie),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTVShowsSection() {
    return Padding(
      padding: AppConstants.padding(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalization.homeTvShows.tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          AppConstants.spacingY(AppConstants.spacing16),
          if (widget.controller.isLoadingTVShows)
            const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.controller.tvShowsError != null)
            SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppLocalization.homeError.tr()}: ${widget.controller.tvShowsError}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    AppConstants.spacingY(AppConstants.spacing8),
                    ElevatedButton(
                      onPressed: () => widget.controller.loadTVShows(),
                      child: Text(AppLocalization.homeRetry.tr()),
                    ),
                  ],
                ),
              ),
            )
          else if (widget.controller.tvShows.isEmpty)
            SizedBox(
              height: 280,
              child: Center(
                child: Text(AppLocalization.homeNoTVShowsAvailable.tr()),
              ),
            )
          else
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.controller.tvShows.length,
                itemBuilder: (context, index) {
                  final tvShow = widget.controller.tvShows[index];
                  return Padding(
                    padding: AppConstants.paddingOnly(
                      right: index == widget.controller.tvShows.length - 1
                          ? AppConstants.spacing0
                          : AppConstants.spacing12,
                    ),
                    child: TVShowCard(tvShow: tvShow),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
