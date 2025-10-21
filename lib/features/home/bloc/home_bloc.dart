import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_events.dart';
import 'home_states.dart';
import '../repo/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeLoading()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        repository.fetchMovies(),
        repository.fetchTvShows(),
      ]);
      final movies = results[0] as List<MovieItem>;
      final tvShows = results[1] as List<TvItem>;
      emit(HomeLoaded(movies: movies, tvShows: tvShows));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        repository.fetchMovies(),
        repository.fetchTvShows(),
      ]);
      final movies = results[0] as List<MovieItem>;
      final tvShows = results[1] as List<TvItem>;
      emit(HomeLoaded(movies: movies, tvShows: tvShows));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
