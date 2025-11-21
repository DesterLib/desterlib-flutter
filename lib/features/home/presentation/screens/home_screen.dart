import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localization.dart';
import '../controllers/home_controller.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_show_card.dart';

class HomeScreen extends StatefulWidget {
  final HomeController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    widget.controller.loadAll();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.appTitle.tr()),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => widget.controller.loadAll(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movies Section
              _buildMoviesSection(),

              const SizedBox(height: 24),

              // TV Shows Section
              _buildTVShowsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalization.movies.tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (widget.controller.isLoadingMovies)
            const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.controller.moviesError != null)
            SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppLocalization.error.tr()}: ${widget.controller.moviesError}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => widget.controller.loadMovies(),
                      child: Text(AppLocalization.retry.tr()),
                    ),
                  ],
                ),
              ),
            )
          else if (widget.controller.movies.isEmpty)
            SizedBox(
              height: 280,
              child: Center(
                child: Text(AppLocalization.noMoviesAvailable.tr()),
              ),
            )
          else
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.controller.movies.length,
                itemBuilder: (context, index) {
                  final movie = widget.controller.movies[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == widget.controller.movies.length - 1
                          ? 0
                          : 12,
                    ),
                    child: MovieCard(movie: movie),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTVShowsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalization.tvShows.tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (widget.controller.isLoadingTVShows)
            const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.controller.tvShowsError != null)
            SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppLocalization.error.tr()}: ${widget.controller.tvShowsError}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => widget.controller.loadTVShows(),
                      child: Text(AppLocalization.retry.tr()),
                    ),
                  ],
                ),
              ),
            )
          else if (widget.controller.tvShows.isEmpty)
            SizedBox(
              height: 280,
              child: Center(
                child: Text(AppLocalization.noTVShowsAvailable.tr()),
              ),
            )
          else
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.controller.tvShows.length,
                itemBuilder: (context, index) {
                  final tvShow = widget.controller.tvShows[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == widget.controller.tvShows.length - 1
                          ? 0
                          : 12,
                    ),
                    child: TVShowCard(tvShow: tvShow),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
