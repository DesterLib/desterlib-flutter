import 'package:desterlib_client/features/widgets/media_card.dart';
import 'package:desterlib_client/features/widgets/media_item.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

class ScrollList extends StatelessWidget {
  const ScrollList({
    super.key,
    required this.items,
    required this.title,
    this.cardWidth = 180,
  });

  final String title;
  final List<MediaItem> items;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20)),
        SizedBox(
          height: cardWidth * 3 / 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ListView.separated(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, _) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final item = items[index];
                return MediaCard(
                  imageUrl: item.poster,
                  onTap: () {
                    final path = switch (item.type) {
                      MediaType.movie => '/media/movie',
                      MediaType.show => '/media/show',
                    };
                    context.push(path);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
