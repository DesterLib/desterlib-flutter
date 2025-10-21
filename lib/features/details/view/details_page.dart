import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/details_bloc.dart';
import '../bloc/details_events.dart';
import '../bloc/details_states.dart';
import '../repo/details_repository.dart';
import '../widgets/movie_details_view.dart';
import '../widgets/tvshow_details_view.dart';
import '../../../video_player/video_player.dart';

class DetailsPage extends StatelessWidget {
  final String
  mediaId; // This is the movie/tvshow record ID for fetching details
  final String mediaType; // 'MOVIE' or 'TV_SHOW'
  final DetailsRepository detailsRepository;

  const DetailsPage({
    super.key,
    required this.mediaId,
    required this.mediaType,
    required this.detailsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = DetailsBloc(repository: detailsRepository);
        if (mediaType == 'MOVIE') {
          bloc.add(MovieDetailsLoadRequested(movieId: mediaId));
        } else {
          bloc.add(TvShowDetailsLoadRequested(tvShowId: mediaId));
        }
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            if (state is DetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            } else if (state is DetailsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            } else if (state is MovieDetailsLoaded) {
              return MovieDetailsView(
                movie: state.movie,
                onPlay: () => _playMovie(context, state.movie.streamUrl),
              );
            } else if (state is TvShowDetailsLoaded) {
              return TvShowDetailsView(
                tvShow: state.tvShow,
                onPlayEpisode: (streamUrl) => _playEpisode(context, streamUrl),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _playMovie(BuildContext context, String streamUrl) {
    // Show video player as fullscreen dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      useSafeArea: false,
      builder: (context) =>
          VideoPlayerPage(videoUrl: streamUrl, title: 'Movie'),
    );
  }

  void _playEpisode(BuildContext context, String streamUrl) {
    // Show video player as fullscreen dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      useSafeArea: false,
      builder: (context) =>
          VideoPlayerPage(videoUrl: streamUrl, title: 'Episode'),
    );
  }
}
