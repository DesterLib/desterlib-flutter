import 'package:flutter/material.dart';
import '../models/season.dart';

class SeasonSelector extends StatelessWidget {
  final List<Season> seasons;
  final Season selectedSeason;
  final ValueChanged<Season> onSeasonChanged;

  const SeasonSelector({
    super.key,
    required this.seasons,
    required this.selectedSeason,
    required this.onSeasonChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity( 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity( 0.1),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Season>(
          value: selectedSeason,
          isExpanded: true,
          dropdownColor: Colors.grey.shade900,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          items: seasons.map((season) {
            return DropdownMenuItem<Season>(
              value: season,
              child: Text(
                '${season.displayName} (${season.episodeCount} episodes)',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (Season? newSeason) {
            if (newSeason != null) {
              onSeasonChanged(newSeason);
            }
          },
        ),
      ),
    );
  }
}
