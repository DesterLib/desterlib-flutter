import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Text(
          'Seasons',
          style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        ),
        AppSpacing.gapVerticalMD,
        ...widget.seasons.asMap().entries.map((entry) {
          final index = entry.key;
          final season = entry.value;
          final isExpanded = _expandedSeasonIndex == index;

          return _SeasonCard(
            season: season,
            isExpanded: isExpanded,
            onToggle: () {
              HapticFeedback.lightImpact();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Season header
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggle,
                onTapDown: (_) => HapticFeedback.lightImpact(),
                child: Padding(
                  padding: EdgeInsets.all(
                    isMobile ? AppSpacing.sm : AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      // Season poster thumbnail
                      if (season.posterUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: DCachedImage(
                            imageUrl: season.posterUrl!,
                            width: isMobile ? 50 : 60,
                            height: isMobile ? 75 : 90,
                            fit: BoxFit.cover,
                            cacheWidth: 240,
                            cacheHeight: 360,
                            showLoadingIndicator: false,
                            errorWidget: Container(
                              width: isMobile ? 50 : 60,
                              height: isMobile ? 75 : 90,
                              color: AppColors.surface,
                              child: Icon(
                                Icons.movie,
                                color: AppColors.textSecondary,
                                size: isMobile ? 20 : 24,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: isMobile ? 50 : 60,
                          height: isMobile ? 75 : 90,
                          decoration: ShapeDecoration(
                            color: AppColors.surface,
                            shape: RoundedSuperellipseBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Icon(
                            Icons.movie,
                            color: AppColors.textSecondary,
                            size: isMobile ? 20 : 24,
                          ),
                        ),
                      SizedBox(width: isMobile ? AppSpacing.sm : AppSpacing.md),

                      // Season info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              season.name ??
                                  'Season ${season.seasonNumber ?? 'Unknown'}',
                              style:
                                  (isMobile
                                          ? AppTypography.bodyLarge
                                          : AppTypography.h3)
                                      .copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '$episodeCount episode${episodeCount != 1 ? 's' : ''}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (season.airDate != null) ...[
                                  Text(
                                    ' • ${season.airDate!.year}',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs),

                      // Expand icon
                      Container(
                        padding: EdgeInsets.all(AppSpacing.xxs),
                        decoration: ShapeDecoration(
                          color: AppColors.surface,
                          shape: RoundedSuperellipseBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Episodes list
            if (isExpanded && episodes.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: episodes.map((episode) {
                    return _EpisodeItem(
                      episode: episode,
                      onPlay: onEpisodePlay,
                      isMobile: isMobile,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EpisodeItem extends StatelessWidget {
  final ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner episode;
  final Function(String episodeId, String episodeTitle)? onPlay;
  final bool isMobile;

  const _EpisodeItem({
    required this.episode,
    this.onPlay,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnailWidth = isMobile ? 100.0 : 140.0;
    final thumbnailHeight = isMobile ? 56.0 : 79.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onPlay != null && episode.id != null) {
            HapticFeedback.lightImpact();
            onPlay!(
              episode.id!,
              episode.title ?? 'Episode ${episode.episodeNumber ?? 'Unknown'}',
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(isMobile ? AppSpacing.sm : AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Episode thumbnail with play overlay
              Stack(
                alignment: Alignment.center,
                children: [
                  if (episode.stillUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DCachedImage(
                        imageUrl: episode.stillUrl!,
                        width: thumbnailWidth,
                        height: thumbnailHeight,
                        fit: BoxFit.cover,
                        cacheWidth: 480,
                        cacheHeight: 270,
                        showLoadingIndicator: false,
                        errorWidget: Container(
                          width: thumbnailWidth,
                          height: thumbnailHeight,
                          color: AppColors.surface,
                          child: Icon(
                            Icons.play_circle_outline,
                            color: AppColors.textSecondary,
                            size: isMobile ? 24 : 32,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: thumbnailWidth,
                      height: thumbnailHeight,
                      decoration: ShapeDecoration(
                        color: AppColors.surface,
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Icon(
                        Icons.play_circle_outline,
                        color: AppColors.textSecondary,
                        size: isMobile ? 24 : 32,
                      ),
                    ),
                  // Play overlay
                  Container(
                    width: isMobile ? 32 : 40,
                    height: isMobile ? 32 : 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: isMobile ? 20 : 24,
                    ),
                  ),
                ],
              ),
              SizedBox(width: isMobile ? AppSpacing.sm : AppSpacing.md),

              // Episode info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Episode number and title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 4,
                          ),
                          decoration: ShapeDecoration(
                            color: AppColors.surface,
                            shape: RoundedSuperellipseBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'E${episode.episodeNumber ?? '?'}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        if (!isMobile && episode.runtime != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 4,
                            ),
                            decoration: ShapeDecoration(
                              color: AppColors.surface,
                              shape: RoundedSuperellipseBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              '${episode.runtime}m',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      episode.title ??
                          'Episode ${episode.episodeNumber ?? 'Unknown'}',
                      style:
                          (isMobile
                                  ? AppTypography.bodySmall
                                  : AppTypography.bodyBase)
                              .copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                      maxLines: isMobile ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (episode.overview != null &&
                        episode.overview!.isNotEmpty &&
                        !isMobile) ...[
                      const SizedBox(height: 4),
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
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
