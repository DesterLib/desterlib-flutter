import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/scrollable_list.dart';
import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isContentLoaded = false;
  List<DCardData>? _movies;
  List<DCardData>? _tvShows;

  @override
  void initState() {
    super.initState();
    // Defer content loading until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isContentLoaded = true;
          _movies = _generateMovies();
          _tvShows = _generateTvShows();
        });
      }
    });
  }

  List<DCardData> _generateMovies() {
    return List.generate(
      10,
      (index) => DCardData(
        title: 'Movie ${index + 1}',
        year: '${2020 + index}',
        onTap: () {
          context.push('/media/${index + 1}');
        },
      ),
    );
  }

  List<DCardData> _generateTvShows() {
    return List.generate(
      10,
      (index) => DCardData(
        title: 'TV Show ${index + 1}',
        year: '${2018 + index}',
        onTap: () {
          context.push('/media/${index + 20}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAppBarPage(
      title: 'Home',
      child: _isContentLoaded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                DScrollableList(title: 'Movies', items: _movies!),
                const SizedBox(height: 32),
                DScrollableList(title: 'TV Shows', items: _tvShows!),
                const SizedBox(height: 24),
              ],
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
