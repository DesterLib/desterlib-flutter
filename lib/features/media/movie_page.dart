import 'package:desterlib_client/core/app/app_background_state.dart';
import 'package:desterlib_client/core/widgets/app_icon.dart';
import 'package:desterlib_client/core/widgets/button.dart';
import 'package:desterlib_client/features/widgets/fade_image.dart';
import 'package:flutter/widgets.dart';
import 'package:desterlib_client/core/utils/extract_colors.dart';
import 'package:go_router/go_router.dart';

const _posterUrl =
    'https://image.tmdb.org/t/p/w780/8U6ww9eHilD88wmU3CDF4ANmRmH.jpg';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.background});

  final AppBackgroundState background;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late Future<List<Color>> _colorsFuture;

  @override
  void initState() {
    super.initState();

    _colorsFuture = extractColors(_posterUrl);

    _colorsFuture.then((colors) {
      if (!mounted) return;
      widget.background.setColors(colors);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isCompact = width < 1400;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            child: isCompact
                ? Column(
                    children: [
                      HeroImage(compact: true),
                      HeroContent(compact: true),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      HeroContent(),
                      Expanded(child: HeroImage()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class HeroContent extends StatelessWidget {
  const HeroContent({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? double.infinity : 360,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Image.network(
                "https://image.tmdb.org/t/p/original/7j3nPn9CMYctl1KVcwBxVAu6vb1.png",
                fit: BoxFit.contain,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }

                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text("Dune: Part Two", style: TextStyle(fontSize: 24)),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Text(
                    "Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the known universe, Paul endeavors to prevent a terrible future only he can foresee.",
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    spacing: 12,
                    children: [
                      Button(
                        label: "Watch Now",
                        onPressed: () {
                          context.push("/player/123");
                        },
                        icon: (context, color, size, iconKey) {
                          return AppIcon(
                            key: key,
                            icon: AppIcons.play,
                            color: color,
                            size: 16,
                          );
                        },
                      ),
                      Button(
                        variant: ButtonVariant.secondary,
                        label: "Play Trailer",
                        onPressed: () {
                          print("Hello");
                        },
                        icon: (context, color, size, iconKey) {
                          return AppIcon(
                            key: key,
                            icon: AppIcons.play,
                            color: color,
                            size: 16,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  const HeroImage({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FadeImage(
      leftFade: compact ? 0 : 0.2,
      bottomFade: 0.1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Image.network(
          _posterUrl,
          fit: BoxFit.contain,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }

            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'No image',
                style: TextStyle(color: Color(0x66FFFFFF)),
              ),
            );
          },
        ),
      ),
    );
  }
}
