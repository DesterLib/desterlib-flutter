// External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/utils/api_config_helper.dart';
import 'package:dester/features/connection/domain/entities/connection_status.dart';

// Features
import 'package:dester/features/home/domain/entities/movie.dart';
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'package:dester/features/home/domain/usecases/get_movies_list.dart';
import 'package:dester/features/home/domain/usecases/get_tv_shows_list.dart';

/// State for home screen
class HomeState {
  final List<Movie> movies;
  final List<TVShow> tvShows;
  final bool isLoadingMovies;
  final bool isLoadingTVShows;
  final String? moviesError;
  final String? tvShowsError;
  final bool hasInitiallyLoaded;

  const HomeState({
    this.movies = const [],
    this.tvShows = const [],
    this.isLoadingMovies = false,
    this.isLoadingTVShows = false,
    this.moviesError,
    this.tvShowsError,
    this.hasInitiallyLoaded = false,
  });

  HomeState copyWith({
    List<Movie>? movies,
    List<TVShow>? tvShows,
    bool? isLoadingMovies,
    bool? isLoadingTVShows,
    String? moviesError,
    String? tvShowsError,
    bool? hasInitiallyLoaded,
    bool clearMoviesError = false,
    bool clearTVShowsError = false,
  }) {
    return HomeState(
      movies: movies ?? this.movies,
      tvShows: tvShows ?? this.tvShows,
      isLoadingMovies: isLoadingMovies ?? this.isLoadingMovies,
      isLoadingTVShows: isLoadingTVShows ?? this.isLoadingTVShows,
      moviesError: clearMoviesError ? null : (moviesError ?? this.moviesError),
      tvShowsError: clearTVShowsError
          ? null
          : (tvShowsError ?? this.tvShowsError),
      hasInitiallyLoaded: hasInitiallyLoaded ?? this.hasInitiallyLoaded,
    );
  }
}

/// Controller for home screen using Riverpod Notifier
class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Check connection status (using read to avoid unnecessary rebuilds)
    // The connection guard will invalidate this controller when connection is established
    final connectionState = ref.read(connectionGuardProvider);

    // Only load data if connection is established
    // This controller is invalidated by connection guard when connection is established,
    // so we can safely check and load here
    if (connectionState.status == ConnectionStatus.connected) {
      // Load data asynchronously after build completes
      Future.microtask(() => loadAll());
    }

    // Return initial state (will be updated by loadAll when data is loaded)
    return const HomeState();
  }

  Future<void> loadMovies() async {
    state = state.copyWith(isLoadingMovies: true, clearMoviesError: true);

    final getMoviesList = ref.read(getMoviesListProvider);
    final result = await getMoviesList();

    result.fold(
      onSuccess: (movies) {
        state = state.copyWith(
          movies: movies,
          isLoadingMovies: false,
          clearMoviesError: true,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(
          movies: [],
          isLoadingMovies: false,
          moviesError: failure.message,
        );
      },
    );
  }

  Future<void> loadTVShows() async {
    state = state.copyWith(isLoadingTVShows: true, clearTVShowsError: true);

    final getTVShowsList = ref.read(getTVShowsListProvider);
    final result = await getTVShowsList();

    result.fold(
      onSuccess: (tvShows) {
        state = state.copyWith(
          tvShows: tvShows,
          isLoadingTVShows: false,
          clearTVShowsError: true,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(
          tvShows: [],
          isLoadingTVShows: false,
          tvShowsError: failure.message,
        );
      },
    );
  }

  Future<void> loadAll({bool force = false}) async {
    // Check if API is configured before attempting to load
    if (!ApiConfigHelper.isApiConfigured()) {
      return;
    }

    // Skip if already loaded and not forcing a refresh
    if (state.hasInitiallyLoaded && !force) {
      return;
    }

    await Future.wait([loadMovies(), loadTVShows()]);
    state = state.copyWith(hasInitiallyLoaded: true);
  }
}

/// Provider for GetMoviesList use case
final getMoviesListProvider = Provider<GetMoviesList>((ref) {
  // Implementation will be provided via override in home_feature.dart
  throw UnimplementedError(
    'GetMoviesListProvider must be overridden. Call HomeFeature.setupProviders() first.',
  );
});

/// Provider for GetTVShowsList use case
final getTVShowsListProvider = Provider<GetTVShowsList>((ref) {
  // Implementation will be provided via override in home_feature.dart
  throw UnimplementedError(
    'GetTVShowsListProvider must be overridden. Call HomeFeature.setupProviders() first.',
  );
});

/// Provider for HomeController
final homeControllerProvider = NotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});
