import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import 'package:dester/shared/widgets/ui/search_field.dart';
import 'package:dester/features/library/presentation/provider/genres_provider.dart';
import 'package:dester/features/library/presentation/provider/media_search_provider.dart';
import 'package:dester/features/library/presentation/provider/library_search_provider.dart';
import 'package:dester/features/library/presentation/utils/genre_color_generator.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize search from provider or query params
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSearch();
    });
  }

  @override
  void didUpdateWidget(LibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update search when widget updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSearchFromProvider();
    });
  }

  void _initializeSearch() {
    final uri = GoRouterState.of(context).uri;

    // Handle focus parameter (for bottom nav search button or sidebar)
    if (uri.queryParameters['focus'] == 'search') {
      // Delay focus request to ensure widget is fully built
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      });
      // Clean up URL
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          context.go('/library');
        }
      });
      return;
    }

    // Otherwise sync from provider
    _syncSearchFromProvider();
  }

  void _syncSearchFromProvider() {
    // Watch the search provider and update local state
    final providerQuery = ref.read(librarySearchProvider);
    if (providerQuery.isNotEmpty && providerQuery != _searchQuery) {
      setState(() {
        _searchController.text = providerQuery;
        _searchQuery = providerQuery.toLowerCase();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genres = ref.watch(genresProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 900;

    // Listen to provider changes
    ref.listen<String>(librarySearchProvider, (previous, next) {
      if (next != _searchQuery) {
        setState(() {
          _searchController.text = next;
          _searchQuery = next.toLowerCase();
        });
      }
    });

    return AnimatedAppBarPage(
      title: 'Library',
      useCompactHeight: showSidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar - hidden on desktop since sidebar has it
          if (!showSidebar) ...[
            const SizedBox(height: 24),
            _buildSearchBar(),
            const SizedBox(height: 32),
          ] else
            const SizedBox(height: 24),
          // Show media search results or genre cards
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, showSidebar ? 44 : 24, 24),
            child: _searchQuery.isEmpty
                ? _buildGenreGrid(genres)
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DSearchField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        hintText: 'Search genres...',
        searchQuery: _searchQuery,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
          // Update provider when typing on mobile
          ref.read(librarySearchProvider.notifier).setQuery(value);
        },
        onClear: () {
          setState(() {
            _searchController.clear();
            _searchQuery = '';
          });
          // Clear provider as well
          ref.read(librarySearchProvider.notifier).clear();
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    final searchAsync = ref.watch(mediaSearchProvider(_searchQuery));

    return searchAsync.when(
      data: (results) {
        final movieCards = <DCardData>[];
        for (final movie in results.movies) {
          final media = movie.media;
          movieCards.add(
            DCardData(
              title: media?.title ?? 'Unknown Title',
              year: media?.releaseDate?.year.toString() ?? '',
              imageUrl: media?.backdropUrl ?? media?.posterUrl,
              onTap: () {
                final movieId = movie.id;
                if (movieId != null) {
                  context.push('/media/$movieId?type=MOVIE');
                }
              },
            ),
          );
        }

        final tvShowCards = <DCardData>[];
        for (final tvShow in results.tvShows) {
          final media = tvShow.media;
          tvShowCards.add(
            DCardData(
              title: media?.title ?? 'Unknown Title',
              year: media?.releaseDate?.year.toString() ?? '',
              imageUrl: media?.backdropUrl ?? media?.posterUrl,
              onTap: () {
                final tvShowId = tvShow.id;
                if (tvShowId != null) {
                  context.push('/media/$tvShowId?type=TV_SHOW');
                }
              },
            ),
          );
        }

        final allCards = [...movieCards, ...tvShowCards];

        if (allCards.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Text(
                'No results found for "$_searchQuery"',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Use row-based layout for proper full-width distribution
        final screenWidth = MediaQuery.of(context).size.width;
        final showSidebar = screenWidth > 900;
        final gridSpacing = showSidebar ? 24.0 : 16.0;

        // Account for sidebar width on desktop (340px) and horizontal padding (24 left + 20 right = 44 on desktop, 48 on mobile)
        final sidebarWidth = showSidebar ? 340 : 0;
        final horizontalPadding = showSidebar ? 44 : 48;
        final availableWidth = screenWidth - sidebarWidth - horizontalPadding;
        final crossAxisCount = _getResponsiveCrossAxisCount(availableWidth);

        // Calculate number of rows needed
        final rowCount = (allCards.length / crossAxisCount).ceil();

        return Column(
          children: List.generate(rowCount, (rowIndex) {
            final startIndex = rowIndex * crossAxisCount;
            final endIndex = (startIndex + crossAxisCount).clamp(
              0,
              allCards.length,
            );
            final rowCards = allCards.sublist(startIndex, endIndex);

            // Build row children with spacing
            final rowChildren = <Widget>[];
            for (int colIndex = 0; colIndex < crossAxisCount; colIndex++) {
              if (colIndex < rowCards.length) {
                // Add card
                final card = rowCards[colIndex];
                rowChildren.add(
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 2 / 3, // Poster aspect ratio
                      child: DCard(
                        title: card.title,
                        year: card.year,
                        imageUrl: card.imageUrl,
                        onTap: card.onTap,
                        isInGrid: true,
                      ),
                    ),
                  ),
                );
              } else {
                // Add empty spacer for missing cards
                rowChildren.add(const Expanded(child: SizedBox.shrink()));
              }

              // Add spacing between columns (except after last column)
              if (colIndex < crossAxisCount - 1) {
                rowChildren.add(SizedBox(width: gridSpacing));
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex < rowCount - 1 ? gridSpacing : 0,
              ),
              child: Row(children: rowChildren),
            );
          }),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: DLoadingIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(PlatformIcons.errorCircle, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error searching media',
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreGrid(List<String> genres) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final showSidebar = screenWidth > 900;
        final gridSpacing = showSidebar ? 24.0 : 16.0;

        // Account for sidebar width on desktop (340px) and horizontal padding (24 left + 20 right = 44 on desktop, 48 on mobile)
        final sidebarWidth = showSidebar ? 340 : 0;
        final horizontalPadding = showSidebar ? 44 : 48;
        final availableWidth = screenWidth - sidebarWidth - horizontalPadding;
        final crossAxisCount = _getResponsiveCrossAxisCount(availableWidth);

        // Calculate number of rows needed
        final rowCount = (genres.length / crossAxisCount).ceil();

        return Column(
          children: List.generate(rowCount, (rowIndex) {
            final startIndex = rowIndex * crossAxisCount;
            final endIndex = (startIndex + crossAxisCount).clamp(
              0,
              genres.length,
            );
            final rowGenres = genres.sublist(startIndex, endIndex);

            // Build row children with spacing
            final rowChildren = <Widget>[];
            for (int colIndex = 0; colIndex < crossAxisCount; colIndex++) {
              if (colIndex < rowGenres.length) {
                // Add genre card
                final genre = rowGenres[colIndex];
                rowChildren.add(
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1 / 0.6,
                      child: _GenreCard(
                        genre: genre,
                        onTap: () {
                          // TODO: Navigate to genre detail screen
                        },
                      ),
                    ),
                  ),
                );
              } else {
                // Add empty spacer for missing cards
                rowChildren.add(const Expanded(child: SizedBox.shrink()));
              }

              // Add spacing between columns (except after last column)
              if (colIndex < crossAxisCount - 1) {
                rowChildren.add(SizedBox(width: gridSpacing));
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex < rowCount - 1 ? gridSpacing : 0,
              ),
              child: Row(children: rowChildren),
            );
          }),
        );
      },
    );
  }

  int _getResponsiveCrossAxisCount(double availableWidth) {
    if (availableWidth < 600) {
      return 2; // Mobile: 2 columns
    } else if (availableWidth < 900) {
      return 3; // Tablet: 3 columns
    } else if (availableWidth < 1200) {
      return 4; // Desktop: 4 columns
    } else if (availableWidth < 1600) {
      return 5; // Large Desktop: 5 columns
    } else {
      return 6; // Extra Large: 6 columns
    }
  }
}

class _GenreCard extends StatefulWidget {
  final String genre;
  final VoidCallback? onTap;

  const _GenreCard({required this.genre, this.onTap});

  @override
  State<_GenreCard> createState() => _GenreCardState();
}

class _GenreCardState extends State<_GenreCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Generate mesh gradient colors deterministically from genre name
    final originalColors = GenreColorGenerator.generateMeshColors(widget.genre);

    // Create dramatic dark mesh with light spots
    // First color stays relatively bright (the light spot)
    // Other colors are darkened significantly (the dark base)
    final meshColors = List.generate(originalColors.length, (index) {
      final hsl = HSLColor.fromColor(originalColors[index]);

      if (index == 0) {
        // Keep first color brighter for the light spot (50-70% lightness)
        final targetLightness = (hsl.lightness * 0.8).clamp(0.5, 0.7);
        return hsl.withLightness(targetLightness).toColor();
      } else {
        // Make other colors much darker (15-30% lightness)
        final targetLightness = (hsl.lightness * 0.4).clamp(0.15, 0.3);
        return hsl.withLightness(targetLightness).toColor();
      }
    });

    // Split genre name into words for multi-line display
    final words = widget.genre.split(' ');
    final displayText = words.length > 1 && widget.genre.length > 12
        ? words.join('\n')
        : widget.genre;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap != null
            ? () {
                HapticFeedback.lightImpact();
                widget.onTap!();
              }
            : null,
        child: AnimatedScale(
          scale: _isPressed
              ? 0.98
              : _isHovered
              ? 1.02
              : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: ShapeDecoration(
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 0.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              shadows: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: ClipPath(
              clipper: _SuperellipseClipper(borderRadius: 12),
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    // Non-animated mesh gradient background
                    Positioned.fill(
                      child: MeshGradient(
                        points: [
                          MeshGradientPoint(
                            position: const Offset(0.0, 0.0),
                            color: meshColors[0],
                          ),
                          MeshGradientPoint(
                            position: const Offset(1.0, 0.0),
                            color: meshColors[1],
                          ),
                          MeshGradientPoint(
                            position: const Offset(0.0, 1.0),
                            color: meshColors[2],
                          ),
                          MeshGradientPoint(
                            position: const Offset(1.0, 1.0),
                            color: meshColors[3],
                          ),
                        ],
                        options: MeshGradientOptions(
                          blend: 3.5,
                          noiseIntensity: 0.0,
                        ),
                      ),
                    ),
                    // White text overlay
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          displayText,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8,
                            height: 1.1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom clipper for superellipse shape
class _SuperellipseClipper extends CustomClipper<Path> {
  final double borderRadius;

  _SuperellipseClipper({required this.borderRadius});

  @override
  Path getClip(Size size) {
    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
    return shape.getOuterPath(Offset.zero & size);
  }

  @override
  bool shouldReclip(_SuperellipseClipper oldClipper) {
    return oldClipper.borderRadius != borderRadius;
  }
}
