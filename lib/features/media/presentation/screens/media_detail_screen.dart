import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import '../widgets/media_data.dart';
import '../widgets/media_hero_section.dart';
import '../widgets/media_genres_section.dart';
import '../widgets/tv_show_seasons_section.dart';
import '../provider/media_detail_provider.dart';

class MediaDetailScreen extends ConsumerWidget {
  final String id;
  final String? mediaType;

  const MediaDetailScreen({super.key, required this.id, this.mediaType});

  void _handlePlayTapped(BuildContext context, String? mediaId) {
    if (mediaId == null) return;

    // TODO: Navigate to player screen with mediaId
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing media: $mediaId'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _handleEpisodePlay(
    BuildContext context,
    String episodeId,
    String episodeTitle,
  ) {
    // TODO: Navigate to player screen with episodeId
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: $episodeTitle'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final mediaAsync = ref.watch(mediaDetailProvider((id, mediaType)));
    final tvShowDetailsAsync = ref.watch(tvShowDetailsProvider(id));

    return AnimatedAppBarPage(
      title: '', // Hide app bar title on both mobile and desktop
      extendBodyBehindAppBar: true,
      leading: DButton(
        icon: PlatformIcons.arrowBack,
        variant: DButtonVariant.secondary,
        size: DButtonSize.sm,
        onTap: () => context.pop(),
      ),
      child: mediaAsync.when(
        data: (mediaData) {
          if (mediaData == null) {
            return _buildNotFound(context);
          }

          // Check if this is a TV show and get seasons data
          return tvShowDetailsAsync.when(
            data: (tvShowDetails) {
              // Debug: Print seasons data
              if (tvShowDetails?.seasons != null) {
                debugPrint(
                  'TV Show has ${tvShowDetails!.seasons!.length} seasons',
                );
              } else {
                debugPrint('No seasons data available');
              }

              return _MediaDetailContent(
                mediaData: mediaData,
                isMobile: isMobile,
                tvShowSeasons: tvShowDetails?.seasons,
                onPlayTapped: () => _handlePlayTapped(context, mediaData.id),
                onEpisodePlay: (episodeId, episodeTitle) =>
                    _handleEpisodePlay(context, episodeId, episodeTitle),
              );
            },
            loading: () => _MediaDetailContent(
              mediaData: mediaData,
              isMobile: isMobile,
              onPlayTapped: () => _handlePlayTapped(context, mediaData.id),
            ),
            error: (error, stack) => _MediaDetailContent(
              mediaData: mediaData,
              isMobile: isMobile,
              onPlayTapped: () => _handlePlayTapped(context, mediaData.id),
            ),
          );
        },
        loading: () => const _LoadingIndicator(),
        error: (error, stack) => _buildError(context, error),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            Text(
              'Media not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'The requested media could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load media',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Content widget containing all sections of the media detail screen
class _MediaDetailContent extends StatelessWidget {
  final MediaData mediaData;
  final bool isMobile;
  final VoidCallback onPlayTapped;
  final BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInner>? tvShowSeasons;
  final Function(String episodeId, String episodeTitle)? onEpisodePlay;

  const _MediaDetailContent({
    required this.mediaData,
    required this.isMobile,
    required this.onPlayTapped,
    this.tvShowSeasons,
    this.onEpisodePlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero section
        MediaHeroSection(
          mediaData: mediaData,
          isMobile: isMobile,
          onPlayTapped: onPlayTapped,
        ),

        // Rest of content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile)
                const SizedBox(height: 24)
              else
                const SizedBox(height: 40),

              // Overview section
              if (mediaData.description.isNotEmpty) ...[
                _OverviewSection(
                  description: mediaData.description,
                  director: mediaData.director,
                  cast: mediaData.cast,
                  isMobile: isMobile,
                ),
              ],

              if (mediaData.genres.isNotEmpty) ...[
                const SizedBox(height: 40),
                MediaGenresSection(genres: mediaData.genres),
              ],
              // Show seasons and episodes for TV shows
              if (tvShowSeasons != null && tvShowSeasons!.isNotEmpty) ...[
                const SizedBox(height: 48),
                TvShowSeasonsSection(
                  seasons: tvShowSeasons!,
                  onEpisodePlay: onEpisodePlay,
                ),
              ],
              const SizedBox(height: 48),
            ],
          ),
        ),
      ],
    );
  }
}

/// Overview section with description and credits
class _OverviewSection extends StatelessWidget {
  final String description;
  final String director;
  final List<String> cast;
  final bool isMobile;

  const _OverviewSection({
    required this.description,
    required this.director,
    required this.cast,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: isMobile ? 14 : 15,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: -0.2,
          ),
        ),

        // Cast and Director
        if (cast.isNotEmpty || director.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              if (director.isNotEmpty)
                _CreditItem(label: 'Director', value: director),
              if (cast.isNotEmpty)
                _CreditItem(label: 'Cast', value: cast.take(3).join(', ')),
            ],
          ),
        ],
      ],
    );
  }
}

/// Credit item widget for director and cast
class _CreditItem extends StatelessWidget {
  final String label;
  final String value;

  const _CreditItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, letterSpacing: -0.2),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading indicator widget
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0a0a0a),
      child: const Center(child: DLoadingIndicator()),
    );
  }
}
