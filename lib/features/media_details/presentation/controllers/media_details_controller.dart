// External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Features
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:dester/features/media_details/domain/usecases/get_movie_details.dart';
import 'package:dester/features/media_details/domain/usecases/get_tv_show_details.dart';

/// State for media details screen
class MediaDetailsState {
  final MediaItem? mediaItem;
  final bool isLoading;
  final String? error;

  const MediaDetailsState({this.mediaItem, this.isLoading = false, this.error});

  MediaDetailsState copyWith({
    MediaItem? mediaItem,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearMediaItem = false,
  }) {
    return MediaDetailsState(
      mediaItem: clearMediaItem ? null : (mediaItem ?? this.mediaItem),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for media details screen
class MediaDetailsController extends Notifier<MediaDetailsState> {
  @override
  MediaDetailsState build() {
    return const MediaDetailsState();
  }

  /// Load movie details by ID
  Future<void> loadMovieDetails(String id) async {
    // Clear old media item immediately to prevent showing old content during navigation
    state = state.copyWith(
      isLoading: true,
      clearMediaItem: true,
      clearError: true,
    );

    try {
      final getMovieDetails = ref.read(getMovieDetailsProvider);
      final movie = await getMovieDetails(id);

      state = state.copyWith(
        mediaItem: MovieMediaItem(movie: movie),
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load TV show details by ID
  Future<void> loadTVShowDetails(String id) async {
    // Clear old media item immediately to prevent showing old content during navigation
    state = state.copyWith(
      isLoading: true,
      clearMediaItem: true,
      clearError: true,
    );

    try {
      final getTVShowDetails = ref.read(getTVShowDetailsProvider);
      final tvShow = await getTVShowDetails(id);

      state = state.copyWith(
        mediaItem: TVShowMediaItem(tvShow: tvShow),
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load media details based on type
  Future<void> loadMediaDetails(String id, MediaType type) async {
    if (type == MediaType.movie) {
      await loadMovieDetails(id);
    } else {
      await loadTVShowDetails(id);
    }
  }

  /// Clear the state immediately (useful when navigating to a new media item)
  void clearState() {
    state = const MediaDetailsState();
  }
}

/// Media type enum
enum MediaType { movie, tvShow }

/// Provider for GetMovieDetails use case
final getMovieDetailsProvider = Provider<GetMovieDetails>((ref) {
  throw UnimplementedError(
    'GetMovieDetailsProvider must be overridden. Call MediaDetailsFeature.setupProviders() first.',
  );
});

/// Provider for GetTVShowDetails use case
final getTVShowDetailsProvider = Provider<GetTVShowDetails>((ref) {
  throw UnimplementedError(
    'GetTVShowDetailsProvider must be overridden. Call MediaDetailsFeature.setupProviders() first.',
  );
});

/// Provider for MediaDetailsController
final mediaDetailsControllerProvider =
    NotifierProvider<MediaDetailsController, MediaDetailsState>(() {
      return MediaDetailsController();
    });
