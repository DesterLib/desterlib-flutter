import 'package:flutter/widgets.dart';
import 'package:desterlib_client/core/utils/extract_colors.dart';

const _posterUrl =
    'https://image.tmdb.org/t/p/w780/8U6ww9eHilD88wmU3CDF4ANmRmH.jpg';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late Future<List<Color>> _colorsFuture;

  @override
  void initState() {
    super.initState();
    _colorsFuture = extractColors(_posterUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          child: Image.network(
            'https://image.tmdb.org/t/p/w780/8U6ww9eHilD88wmU3CDF4ANmRmH.jpg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) =>
                const Center(child: Text('Failed to load')),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Color>>(
          future: _colorsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final colors = snapshot.data!;
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    for (final color in colors)
                      Expanded(child: ColoredBox(color: color)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
