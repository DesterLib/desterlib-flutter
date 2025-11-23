// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';

// Features
import 'package:dester/features/home/domain/entities/tv_show.dart';


class TVShowCard extends StatelessWidget {
  final TVShow tvShow;

  const TVShowCard({super.key, required this.tvShow});

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
                child: tvShow.posterPath != null
                    ? Image.network(
                        tvShow.posterPath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              LucideIcons.tv,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          LucideIcons.tv,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            // TV Show Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: AppConstants.padding(AppConstants.spacing8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvShow.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppConstants.spacingY(AppConstants.spacing4),
                    if (tvShow.rating != null)
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          AppConstants.spacingX(AppConstants.spacing4),
                          Text(
                            tvShow.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    if (tvShow.firstAirDate != null) ...[
                      AppConstants.spacingY(AppConstants.spacing4),
                      Text(
                        tvShow.firstAirDate!,
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
