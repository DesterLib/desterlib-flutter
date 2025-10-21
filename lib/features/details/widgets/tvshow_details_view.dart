import 'package:flutter/material.dart';
import '../models/tvshow_details.dart';
import '../models/season.dart';
import 'episode_list_item.dart';

class TvShowDetailsView extends StatefulWidget {
  final TvShowDetails tvShow;
  final Function(String streamUrl) onPlayEpisode;

  const TvShowDetailsView({
    super.key,
    required this.tvShow,
    required this.onPlayEpisode,
  });

  @override
  State<TvShowDetailsView> createState() => _TvShowDetailsViewState();
}

class _TvShowDetailsViewState extends State<TvShowDetailsView> {
  final Set<String> _expandedSeasons = {};

  @override
  void initState() {
    super.initState();
    // Expand first season by default
    if (widget.tvShow.seasons.isNotEmpty) {
      _expandedSeasons.add(widget.tvShow.seasons.first.id);
    }
  }

  bool _isSeasonExpanded(String seasonId) {
    return _expandedSeasons.contains(seasonId);
  }

  void _toggleSeason(String seasonId) {
    setState(() {
      if (_expandedSeasons.contains(seasonId)) {
        _expandedSeasons.remove(seasonId);
      } else {
        _expandedSeasons.add(seasonId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Backdrop image
          if (widget.tvShow.fullBackdropUrl != null)
            Container(
              constraints: const BoxConstraints(maxHeight: 600, minHeight: 400),
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.tvShow.fullBackdropUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(
                            Icons.tv,
                            size: 64,
                            color: Colors.white24,
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.grey.shade900],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.tvShow.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Metadata row
                    Wrap(
                      spacing: 12,
                      children: [
                        if (widget.tvShow.firstAirDate != null)
                          _buildMetadataChip(
                            icon: Icons.calendar_today,
                            text: widget.tvShow.firstAirDate!.year.toString(),
                          ),
                        _buildMetadataChip(
                          icon: Icons.tv,
                          text: widget.tvShow.formattedSeasons,
                        ),
                        if (widget.tvShow.rating != null)
                          _buildMetadataChip(
                            icon: Icons.star,
                            text: widget.tvShow.formattedRating,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Genres
                    if (widget.tvShow.genres.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.tvShow.genres.map((genre) {
                          return Chip(
                            label: Text(genre),
                            backgroundColor: Colors.blue.withValues(alpha: 0.2),
                            labelStyle: const TextStyle(color: Colors.white),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Description
                    if (widget.tvShow.description != null) ...[
                      const Text(
                        'Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tvShow.description!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Creator & Network
                    if (widget.tvShow.creator != null) ...[
                      _buildInfoRow('Creator', widget.tvShow.creator!),
                      const SizedBox(height: 12),
                    ],
                    if (widget.tvShow.network != null) ...[
                      _buildInfoRow('Network', widget.tvShow.network!),
                      const SizedBox(height: 12),
                    ],

                    // Cast
                    if (widget.tvShow.cast.isNotEmpty) ...[
                      _buildInfoRow(
                        'Cast',
                        widget.tvShow.cast.take(5).join(', '),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Episodes section
                    if (widget.tvShow.seasons.isNotEmpty) ...[
                      const Text(
                        'Seasons & Episodes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Seasons accordion
                      ...widget.tvShow.seasons.map((season) {
                        final isExpanded = _isSeasonExpanded(season.id);
                        return Column(
                          children: [
                            _buildSeasonHeader(season, isExpanded),
                            if (isExpanded) _buildEpisodesList(season),
                            const SizedBox(height: 8),
                          ],
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonHeader(Season season, bool isExpanded) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleSeason(season.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${season.episodeCount} episode${season.episodeCount != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodesList(Season season) {
    if (season.episodes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No episodes available for this season',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: season.episodes.map((episode) {
          return EpisodeListItem(
            episode: episode,
            onPlay: () => widget.onPlayEpisode(episode.streamUrl),
          );
        }).toList(),
      ),
    );
  }
}
