import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/scrollable_list.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import '../widgets/media_data.dart';
import '../widgets/media_hero_section.dart';
import '../widgets/media_info_section.dart';
import '../widgets/media_genres_section.dart';

class MediaDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const MediaDetailScreen({super.key, required this.id});

  @override
  ConsumerState<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends ConsumerState<MediaDetailScreen> {
  bool _isContentLoaded = false;
  MediaData? _mediaData;
  List<DCardData>? _relatedMedia;

  @override
  void initState() {
    super.initState();
    // Defer content loading until after first frame for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isContentLoaded = true;
          _mediaData = _loadMediaData();
          _relatedMedia = _generateRelatedMedia();
        });
      }
    });
  }

  MediaData _loadMediaData() {
    // Mock data - in a real app, this would fetch from an API based on widget.id
    return MediaData(
      id: widget.id,
      title: 'Movie ${widget.id}',
      year: '2024',
      duration: '2h 15m',
      rating: '8.5',
      genres: const ['Action', 'Sci-Fi', 'Thriller'],
      description:
          'An epic tale of adventure and discovery that pushes the boundaries of human imagination. Follow the journey of unlikely heroes as they navigate through dangerous territories and face impossible odds.',
      director: 'John Smith',
      cast: const ['Actor One', 'Actor Two', 'Actor Three', 'Actor Four'],
      imageUrl:
          'https://image.tmdb.org/t/p/w1000_and_h563_face/6gRMfLh7Ohh7doPvLo3J5wF1Xsb.jpg',
    );
  }

  List<DCardData> _generateRelatedMedia() {
    return List.generate(
      8,
      (index) => DCardData(
        title: 'Related ${index + 1}',
        year: '${2020 + index}',
        onTap: () {
          context.push('/media/${index + 100}');
        },
      ),
    );
  }

  void _handlePlayTapped() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Play functionality coming soon!'),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return AnimatedAppBarPage(
      title: '', // Hide app bar title on both mobile and desktop
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: DButton(
          icon: PlatformIcons.arrowBack,
          variant: DButtonVariant.secondary,
          size: DButtonSize.sm,
        ),
      ),
      child: _isContentLoaded && _mediaData != null
          ? _MediaDetailContent(
              mediaData: _mediaData!,
              relatedMedia: _relatedMedia!,
              isMobile: isMobile,
              onPlayTapped: _handlePlayTapped,
            )
          : const _LoadingIndicator(),
    );
  }
}

/// Content widget containing all sections of the media detail screen
class _MediaDetailContent extends StatelessWidget {
  final MediaData mediaData;
  final List<DCardData> relatedMedia;
  final bool isMobile;
  final VoidCallback onPlayTapped;

  const _MediaDetailContent({
    required this.mediaData,
    required this.relatedMedia,
    required this.isMobile,
    required this.onPlayTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero section - extends under app bar on both mobile and desktop
        Transform.translate(
          offset: const Offset(0, -120), // Shift up to extend under app bar
          child: MediaHeroSection(
            mediaData: mediaData,
            isMobile: isMobile,
            onPlayTapped: onPlayTapped,
          ),
        ),

        // Rest of content - always padded and shifted up to account for hero
        Transform.translate(
          offset: const Offset(0, -120), // Shift up to account for hero section
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMobile)
                  const SizedBox(height: 24)
                else
                  const SizedBox(height: 40),
                MediaInfoSection(mediaData: mediaData),
                const SizedBox(height: 40),
                MediaGenresSection(genres: mediaData.genres),
                const SizedBox(height: 48),
                DScrollableList(
                  title: 'Related Media',
                  items: relatedMedia,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Loading indicator widget
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
