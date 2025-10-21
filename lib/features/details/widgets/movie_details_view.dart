import 'package:flutter/material.dart';
import '../models/movie_details.dart';
import '../../../widgets/common/tv_button.dart';

class MovieDetailsView extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback onPlay;

  const MovieDetailsView({
    super.key,
    required this.movie,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Backdrop image
          if (movie.fullBackdropUrl != null)
            Container(
              constraints: const BoxConstraints(maxHeight: 600, minHeight: 400),
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.fullBackdropUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(
                            Icons.movie,
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
                      movie.title,
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
                        if (movie.releaseDate != null)
                          _buildMetadataChip(
                            icon: Icons.calendar_today,
                            text: movie.releaseDate!.year.toString(),
                          ),
                        if (movie.duration != null)
                          _buildMetadataChip(
                            icon: Icons.access_time,
                            text: movie.formattedDuration,
                          ),
                        if (movie.rating != null)
                          _buildMetadataChip(
                            icon: Icons.star,
                            text: movie.formattedRating,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Play button
                    TvButton(
                      onPressed: onPlay,
                      icon: Icons.play_arrow,
                      width: double.infinity,
                      height: 56,
                      backgroundColor: Colors.blue,
                      autofocus: true,
                      child: const Text(
                        'Watch Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Genres
                    if (movie.genres.isNotEmpty) ...[
                      const Text(
                        'Genres',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: movie.genres.map((genre) {
                          return Chip(
                            label: Text(genre),
                            backgroundColor: Colors.blue.withValues(alpha:  0.2),
                            labelStyle: const TextStyle(color: Colors.white),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Description
                    if (movie.description != null) ...[
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
                        movie.description!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha:  0.8),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Director
                    if (movie.director != null) ...[
                      _buildInfoRow('Director', movie.director!),
                      const SizedBox(height: 12),
                    ],

                    // Cast
                    if (movie.cast.isNotEmpty) ...[
                      _buildInfoRow('Cast', movie.cast.take(5).join(', ')),
                      const SizedBox(height: 12),
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
        color: Colors.white.withValues(alpha:  0.1),
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
              color: Colors.white.withValues(alpha:  0.6),
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
}
