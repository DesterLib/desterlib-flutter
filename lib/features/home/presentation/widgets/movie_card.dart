// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';

// Features
import 'package:dester/features/home/domain/entities/movie.dart';


class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[800]),
                child: movie.posterPath != null
                    ? Image.network(
                        movie.posterPath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              LucideIcons.film,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          LucideIcons.film,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            // Movie Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: AppConstants.padding(AppConstants.spacing8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppConstants.spacingY(AppConstants.spacing4),
                    if (movie.rating != null)
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          AppConstants.spacingX(AppConstants.spacing4),
                          Text(
                            movie.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    if (movie.releaseDate != null) ...[
                      AppConstants.spacingY(AppConstants.spacing4),
                      Text(
                        movie.releaseDate!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
