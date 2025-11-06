import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/ui/cached_image.dart';

/// Section showing seasons and episodes for TV shows
class TvShowSeasonsSection extends StatefulWidget {
  final BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInner> seasons;
  final Function(String episodeId, String episodeTitle)? onEpisodePlay;

  const TvShowSeasonsSection({
    super.key,
    required this.seasons,
    this.onEpisodePlay,
  });

  @override
  State<TvShowSeasonsSection> createState() => _TvShowSeasonsSectionState();
}

class _TvShowSeasonsSectionState extends State<TvShowSeasonsSection> {
  int? _expandedSeasonIndex;

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'TvShowSeasonsSection: Building with ${widget.seasons.length} seasons',
    );

    if (widget.seasons.isEmpty) {
      debugPrint('TvShowSeasonsSection: No seasons to display');
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seasons',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.seasons.asMap().entries.map((entry) {
          final index = entry.key;
          final season = entry.value;
          final isExpanded = _expandedSeasonIndex == index;

          return _SeasonCard(
            season: season,
            isExpanded: isExpanded,
            onToggle: () {
              setState(() {
                _expandedSeasonIndex = isExpanded ? null : index;
              });
            },
            onEpisodePlay: widget.onEpisodePlay,
          );
        }),
      ],
    );
  }
}

class _SeasonCard extends StatelessWidget {
  final ApiV1TvshowsIdGet200ResponseDataSeasonsInner season;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(String episodeId, String episodeTitle)? onEpisodePlay;

  const _SeasonCard({
    required this.season,
    required this.isExpanded,
    required this.onToggle,
    this.onEpisodePlay,
  });

  @override
  Widget build(BuildContext context) {
    final episodes =
        season.episodes ??
        BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>();
    final episodeCount = episodes.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          // Season header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Season poster thumbnail
                  if (season.posterUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DCachedImage(
                        imageUrl: season.posterUrl!,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                        // Increased for high-DPI displays (3x = 180x270)
                        cacheWidth: 240,
                        cacheHeight: 360,
                        showLoadingIndicator: false,
                        errorWidget: Container(
                          width: 60,
                          height: 90,
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.movie,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 60,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.movie,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  const SizedBox(width: 16),

                  // Season info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          season.name ??
                              'Season ${season.seasonNumber ?? 'Unknown'}',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$episodeCount episode${episodeCount != 1 ? 's' : ''}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (season.airDate != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${season.airDate!.year}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Expand icon
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Episodes list
          if (isExpanded && episodes.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Column(
                children: episodes.map((episode) {
                  return _EpisodeItem(episode: episode, onPlay: onEpisodePlay);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _EpisodeItem extends StatelessWidget {
  final ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner episode;
  final Function(String episodeId, String episodeTitle)? onPlay;

  const _EpisodeItem({required this.episode, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPlay != null && episode.id != null) {
          onPlay!(
            episode.id!,
            episode.title ?? 'Episode ${episode.episodeNumber ?? 'Unknown'}',
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Episode thumbnail
            if (episode.stillUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DCachedImage(
                  imageUrl: episode.stillUrl!,
                  width: 120,
                  height: 68,
                  fit: BoxFit.cover,
                  // Increased for high-DPI displays (3x = 360x204)
                  cacheWidth: 480,
                  cacheHeight: 270,
                  showLoadingIndicator: false,
                  errorWidget: Container(
                    width: 120,
                    height: 68,
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: AppColors.textSecondary,
                      size: 32,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 120,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_circle_outline,
                  color: AppColors.textSecondary,
                  size: 32,
                ),
              ),
            const SizedBox(width: 16),

            // Episode info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'E${episode.episodeNumber ?? '?'}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          episode.title ??
                              'Episode ${episode.episodeNumber ?? 'Unknown'}',
                          style: AppTypography.bodyBase.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (episode.runtime != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${episode.runtime}m',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (episode.overview != null &&
                      episode.overview!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      episode.overview!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (episode.airDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(episode.airDate!),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Play icon
            const SizedBox(width: 8),
            Icon(Icons.play_arrow, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
