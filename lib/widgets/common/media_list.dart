import 'package:flutter/material.dart';
import 'media_card.dart';
import '../../features/home/repo/home_repository.dart';

class MediaList<T> extends StatelessWidget {
  final List<T> items;
  final void Function(T item) onTap;

  const MediaList({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          String title = '';
          String? backdropUrl;
          String? year;

          if (item is MovieItem) {
            title = item.media.title;
            backdropUrl = item.media.backdropUrl;
            year = item.media.releaseDate?.year.toString();
          } else if (item is TvItem) {
            title = item.media.title;
            backdropUrl = item.media.backdropUrl;
            year = item.media.releaseDate?.year.toString();
          }

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 280,
              child: MediaCard(
                imagePath: backdropUrl ?? '',
                title: title,
                year: year ?? '',
                onTap: () => onTap(item),
              ),
            ),
          );
        },
      ),
    );
  }
}
