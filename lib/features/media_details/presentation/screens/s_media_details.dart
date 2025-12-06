// External packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/utils/color_extractor.dart';
import 'package:dester/core/widgets/d_media_app_bar.dart';
import 'package:dester/core/widgets/d_bottom_nav_space.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_sidebar.dart';
import 'package:dester/core/widgets/d_scaffold.dart';
import 'package:dester/core/widgets/d_spinner.dart';
import 'package:dester/core/widgets/d_scrollview_slider.dart';

// Features
import 'package:dester/features/home/presentation/widgets/hero.dart';
import 'package:dester/features/media_details/presentation/controllers/media_details_controller.dart';
import 'package:dester/features/media_details/presentation/widgets/trailer_card.dart';
import 'package:dester/features/media_details/presentation/widgets/cast_crew_card.dart';

class MediaDetailsScreen extends ConsumerStatefulWidget {
  final String mediaId;
  final MediaType mediaType;
  final String? initialTitle;

  const MediaDetailsScreen({
    super.key,
    required this.mediaId,
    required this.mediaType,
    this.initialTitle,
  });

  @override
  ConsumerState<MediaDetailsScreen> createState() => _MediaDetailsScreenState();
}

class _MediaDetailsScreenState extends ConsumerState<MediaDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Defer loading to avoid modifying provider during build phase
    Future.microtask(() {
      if (mounted) {
        _loadData();
      }
    });
  }

  @override
  void didUpdateWidget(MediaDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If mediaId or mediaType changed, clear state and reload
    if (oldWidget.mediaId != widget.mediaId ||
        oldWidget.mediaType != widget.mediaType) {
      // Clear the old state immediately (synchronously) to prevent showing old content
      final controller = ref.read(mediaDetailsControllerProvider.notifier);
      controller.clearState();
      // Defer loading to avoid modifying provider during build phase
      Future.microtask(() {
        if (mounted) {
          _loadData();
        }
      });
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    final controller = ref.read(mediaDetailsControllerProvider.notifier);
    await controller.loadMediaDetails(widget.mediaId, widget.mediaType);

    // Extract colors for mesh gradient after media loads
    if (mounted) {
      _extractColorsForMediaItem();
    }
  }

  void _extractColorsForMediaItem() {
    final state = ref.read(mediaDetailsControllerProvider);
    final mediaItem = state.mediaItem;

    // Only extract colors if the media item ID matches the current widget's mediaId
    if (mediaItem == null || mediaItem.id != widget.mediaId) return;

    // Determine which image to use for color extraction
    // Only use null images (without text overlays)
    final isMobile = MediaQuery.of(context).size.width < 768;
    String? imageUrl;

    if (isMobile) {
      imageUrl = mediaItem.nullPosterUrl;
    } else {
      imageUrl = mediaItem.nullBackdropUrl ?? mediaItem.nullPosterUrl;
    }

    if (imageUrl != null && mounted) {
      // Prefetch image
      precacheImage(CachedNetworkImageProvider(imageUrl), context).catchError((
        _,
      ) {
        // Ignore prefetch errors
      });

      // Extract colors (async, fire and forget)
      ColorExtractor.extractColorsFromUrl(imageUrl).catchError((_) {
        // Ignore color extraction errors
        return null;
      });
    }

    // Also prefetch logo
    if (mediaItem.logoUrl != null && mounted) {
      precacheImage(
        CachedNetworkImageProvider(mediaItem.logoUrl!),
        context,
      ).catchError((_) {
        // Ignore prefetch errors
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mediaDetailsControllerProvider);
    final controller = ref.read(mediaDetailsControllerProvider.notifier);

    // Calculate hero height same as carousel with max height
    final isMobile = MediaQuery.of(context).size.width < 768;
    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedHeight = isMobile
        ? 600.0 // Fixed mobile height
        : (screenWidth * 0.6) / (16 / 9); // Desktop: 60% width with 16:9 ratio
    final heroHeight = calculatedHeight
        .clamp(0, 600.0)
        .toDouble(); // Max height of 800px

    // Show loading state immediately if no media item or if loading
    // Also check if the current mediaItem ID matches the widget's mediaId
    // This prevents old content from showing during navigation
    final currentMediaId = state.mediaItem?.id;
    final mediaIdMatches = currentMediaId == widget.mediaId;
    final showLoading =
        state.isLoading ||
        (state.mediaItem == null && state.error == null) ||
        (state.mediaItem != null && !mediaIdMatches);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scrollable content
          RefreshIndicator(
            onRefresh: () =>
                controller.loadMediaDetails(widget.mediaId, widget.mediaType),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Error state
                              if (state.error != null && !state.isLoading)
                                Container(
                                  height: heroHeight,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppConstants.spacingLg,
                                    vertical: AppConstants.spacingLg,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 64,
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                        AppConstants.spacingY(
                                          AppConstants.spacingMd,
                                        ),
                                        Text(
                                          'Failed to load media details',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        AppConstants.spacingY(
                                          AppConstants.spacing8,
                                        ),
                                        Text(
                                          state.error ?? 'Unknown error',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.7,
                                            ),
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // Hero Widget - Only show when data is loaded and ID matches
                              if (state.mediaItem != null &&
                                  !state.isLoading &&
                                  mediaIdMatches)
                                SizedBox(
                                  height: heroHeight,
                                  child: HeroWidget(
                                    item: state.mediaItem!,
                                    height: heroHeight,
                                  ),
                                ),

                              // Additional content can be added here
                              // For now, just add some spacing
                              if (state.mediaItem != null &&
                                  !state.isLoading &&
                                  mediaIdMatches)
                                AppConstants.spacingY(AppConstants.spacing24),

                              // Trailers section
                              if (state.mediaItem != null &&
                                  !state.isLoading &&
                                  mediaIdMatches)
                                _buildTrailersSection(),

                              // Cast & Crew section
                              if (state.mediaItem != null &&
                                  !state.isLoading &&
                                  mediaIdMatches)
                                _buildCastCrewSection(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DMediaAppBar(
                      title: (state.mediaItem != null && mediaIdMatches)
                          ? state.mediaItem!.title
                          : (widget.initialTitle ?? 'Loading...'),
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
          // Absolutely positioned loading overlay that ignores safe areas
          if (showLoading)
            Positioned.fill(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                removeLeft: true,
                removeRight: true,
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const DSpinner(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build trailers section
  /// TODO: Replace with actual trailer data from API when available
  Widget _buildTrailersSection() {
    // Placeholder data - replace with actual trailers from mediaItem when API provides them
    final trailers = <Trailer>[
      Trailer(
        id: 'placeholder-1',
        name: 'Official Trailer',
        thumbnailUrl: null,
        videoUrl: null,
        site: 'YouTube',
        key: null,
      ),
      Trailer(
        id: 'placeholder-2',
        name: 'Teaser Trailer',
        thumbnailUrl: null,
        videoUrl: null,
        site: 'YouTube',
        key: null,
      ),
      Trailer(
        id: 'placeholder-3',
        name: 'Behind the Scenes',
        thumbnailUrl: null,
        videoUrl: null,
        site: 'YouTube',
        key: null,
      ),
    ];

    if (trailers.isEmpty) {
      return const SizedBox.shrink();
    }

    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);
    final sidebarTotalWidth = useDesktopLayout ? DSidebar.getTotalWidth() : 0.0;
    final sliderHeight = 200.0;
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
            child: Text('Trailers', style: AppTypography.headlineLarge()),
          ),
        ),
        SizedBox(
          height: sliderHeight,
          child: DScrollViewSlider(
            showNavigationButtons: true,
            builder: (context, scrollController) {
              return ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: padding,
                itemCount: trailers.length,
                itemBuilder: (context, index) {
                  final trailer = trailers[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == trailers.length - 1
                          ? 0
                          : AppConstants.spacing12,
                    ),
                    child: TrailerCard(
                      trailer: trailer,
                      onTap: () {
                        // TODO: Implement trailer playback
                        // Could open in webview, YouTube app, or custom video player
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build cast & crew section
  /// TODO: Replace with actual cast/crew data from API when available
  Widget _buildCastCrewSection() {
    // Placeholder data - replace with actual cast/crew from mediaItem when API provides them
    final cast = <CastCrewMember>[
      CastCrewMember(
        id: 'cast-placeholder-1',
        name: 'John Doe',
        profileImageUrl: null,
        role: 'Actor',
        character: 'Main Character',
      ),
      CastCrewMember(
        id: 'cast-placeholder-2',
        name: 'Jane Smith',
        profileImageUrl: null,
        role: 'Actor',
        character: 'Supporting Role',
      ),
      CastCrewMember(
        id: 'cast-placeholder-3',
        name: 'Bob Johnson',
        profileImageUrl: null,
        role: 'Actor',
        character: 'Antagonist',
      ),
      CastCrewMember(
        id: 'cast-placeholder-4',
        name: 'Alice Williams',
        profileImageUrl: null,
        role: 'Actor',
        character: 'Side Character',
      ),
      CastCrewMember(
        id: 'cast-placeholder-5',
        name: 'Charlie Brown',
        profileImageUrl: null,
        role: 'Actor',
        character: 'Ensemble',
      ),
    ];

    final crew = <CastCrewMember>[
      CastCrewMember(
        id: 'crew-placeholder-1',
        name: 'Director Name',
        profileImageUrl: null,
        role: 'Director',
        character: null,
      ),
      CastCrewMember(
        id: 'crew-placeholder-2',
        name: 'Producer Name',
        profileImageUrl: null,
        role: 'Producer',
        character: null,
      ),
      CastCrewMember(
        id: 'crew-placeholder-3',
        name: 'Writer Name',
        profileImageUrl: null,
        role: 'Writer',
        character: null,
      ),
    ];

    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);
    final sidebarTotalWidth = useDesktopLayout ? DSidebar.getTotalWidth() : 0.0;
    final sliderHeight = 180.0;
    final padding = EdgeInsets.only(
      left: AppConstants.spacing16 + sidebarTotalWidth,
      right: AppConstants.spacing16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cast section
        if (cast.isNotEmpty) ...[
          DSidebarSpace(
            child: Padding(
              padding: AppConstants.padding(AppConstants.spacing16),
              child: Text('Cast', style: AppTypography.headlineLarge()),
            ),
          ),
          SizedBox(
            height: sliderHeight,
            child: DScrollViewSlider(
              showNavigationButtons: true,
              builder: (context, scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: padding,
                  itemCount: cast.length,
                  itemBuilder: (context, index) {
                    final member = cast[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == cast.length - 1
                            ? 0
                            : AppConstants.spacing12,
                      ),
                      child: CastCrewCard(
                        member: member,
                        onTap: () {
                          // TODO: Navigate to person details page
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
        // Crew section
        if (crew.isNotEmpty) ...[
          DSidebarSpace(
            child: Padding(
              padding: AppConstants.padding(AppConstants.spacing16),
              child: Text('Crew', style: AppTypography.headlineLarge()),
            ),
          ),
          SizedBox(
            height: sliderHeight,
            child: DScrollViewSlider(
              showNavigationButtons: true,
              builder: (context, scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: padding,
                  itemCount: crew.length,
                  itemBuilder: (context, index) {
                    final member = crew[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == crew.length - 1
                            ? 0
                            : AppConstants.spacing12,
                      ),
                      child: CastCrewCard(
                        member: member,
                        onTap: () {
                          // TODO: Navigate to person details page
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
