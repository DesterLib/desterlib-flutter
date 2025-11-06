import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/badge.dart';

/// Genres section displaying genre badges
class MediaGenresSection extends StatelessWidget {
  final List<String> genres;

  const MediaGenresSection({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Genres'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genres
              .map(
                (genre) => DBadge(
                  label: genre,
                  fontSize: 12,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

/// Section title widget
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
    );
  }
}
