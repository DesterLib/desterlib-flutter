import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/ui/cached_image.dart';

/// Section showing seasons and episodes for TV shows
class TvShowSeasonsSection extends StatefulWidget {
  final BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInner> seasons;
  final Function(
    String episodeId,
    String episodeTitle,
    int seasonNumber,
    int episodeNumber,
  )?
  onEpisodePlay;

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
    if (widget.seasons.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort seasons by season number (numeric, not string)
    final sortedSeasons = widget.seasons.toList()
      ..sort((a, b) {
        final aNum = a.seasonNumber ?? 0;
        final bNum = b.seasonNumber ?? 0;
        return aNum.compareTo(bNum);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seasons',
          style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        ),
        AppSpacing.gapVerticalMD,
        ...sortedSeasons.asMap().entries.map((entry) {
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

class _SeasonCard extends StatefulWidget {
  final ApiV1TvshowsIdGet200ResponseDataSeasonsInner season;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(
    String episodeId,
    String episodeTitle,
    int seasonNumber,
    int episodeNumber,
  )?
  onEpisodePlay;

  const _SeasonCard({
    required this.season,
    required this.isExpanded,
    required this.onToggle,
    this.onEpisodePlay,
  });

  @override
  State<_SeasonCard> createState() => _SeasonCardState();
}

class _SeasonCardState extends State<_SeasonCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final rawEpisodes =
        widget.season.episodes ??
        BuiltList<ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner>();

    // Sort episodes by episode number (numeric, not string)
    final episodes = rawEpisodes.toList()
      ..sort((a, b) {
        final aNum = a.episodeNumber ?? 0;
        final bNum = b.episodeNumber ?? 0;
        return aNum.compareTo(bNum);
      });

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
            GestureDetector(
              onTapDown: (_) {
                HapticFeedback.lightImpact();
                setState(() => _isPressed = true);
              },
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: widget.onToggle,
              child: AnimatedOpacity(
                opacity: _isPressed ? 0.6 : 1.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: EdgeInsets.all(
                    isMobile ? AppSpacing.sm : AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      // Season poster thumbnail
                      if (widget.season.posterUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: DCachedImage(
                            imageUrl: widget.season.posterUrl!,
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
                              widget.season.name ??
                                  'Season ${widget.season.seasonNumber ?? 'Unknown'}',
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
                                if (widget.season.airDate != null) ...[
                                  Text(
                                    ' • ${widget.season.airDate!.year}',
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
                          widget.isExpanded
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
            if (widget.isExpanded && episodes.isNotEmpty)
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
                      seasonNumber: widget.season.seasonNumber ?? 0,
                      onPlay: widget.onEpisodePlay,
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

class _EpisodeItem extends StatefulWidget {
  final ApiV1TvshowsIdGet200ResponseDataSeasonsInnerEpisodesInner episode;
  final int seasonNumber;
  final Function(
    String episodeId,
    String episodeTitle,
    int seasonNumber,
    int episodeNumber,
  )?
  onPlay;
  final bool isMobile;

  const _EpisodeItem({
    required this.episode,
    required this.seasonNumber,
    this.onPlay,
    this.isMobile = false,
  });

  @override
  State<_EpisodeItem> createState() => _EpisodeItemState();
}

class _EpisodeItemState extends State<_EpisodeItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final thumbnailWidth = widget.isMobile ? 100.0 : 140.0;
    final thumbnailHeight = widget.isMobile ? 56.0 : 79.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        if (widget.onPlay != null && widget.episode.id != null) {
          HapticFeedback.lightImpact();
          widget.onPlay!(
            widget.episode.id!,
            widget.episode.title ??
                'Episode ${widget.episode.episodeNumber ?? 'Unknown'}',
            widget.seasonNumber,
            widget.episode.episodeNumber ?? 0,
          );
        }
      },
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          padding: EdgeInsets.all(
            widget.isMobile ? AppSpacing.sm : AppSpacing.md,
          ),
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
                  if (widget.episode.stillUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DCachedImage(
                        imageUrl: widget.episode.stillUrl!,
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
                            size: widget.isMobile ? 24 : 32,
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
                        size: widget.isMobile ? 24 : 32,
                      ),
                    ),
                  // Play overlay
                  Container(
                    width: widget.isMobile ? 32 : 40,
                    height: widget.isMobile ? 32 : 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: widget.isMobile ? 20 : 24,
                    ),
                  ),
                ],
              ),
              SizedBox(width: widget.isMobile ? AppSpacing.sm : AppSpacing.md),

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
                            'E${widget.episode.episodeNumber ?? '?'}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        if (!widget.isMobile &&
                            widget.episode.runtime != null) ...[
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
                              '${widget.episode.runtime}m',
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
                      widget.episode.title ??
                          'Episode ${widget.episode.episodeNumber ?? 'Unknown'}',
                      style:
                          (widget.isMobile
                                  ? AppTypography.bodySmall
                                  : AppTypography.bodyBase)
                              .copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                      maxLines: widget.isMobile ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.episode.overview != null &&
                        widget.episode.overview!.isNotEmpty &&
                        !widget.isMobile) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.episode.overview!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (widget.episode.airDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(widget.episode.airDate!),
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
