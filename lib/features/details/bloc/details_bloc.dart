import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/details_repository.dart';
import 'details_events.dart';
import 'details_states.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final DetailsRepository repository;

  DetailsBloc({required this.repository}) : super(DetailsInitial()) {
    on<MovieDetailsLoadRequested>(_onMovieDetailsLoadRequested);
    on<TvShowDetailsLoadRequested>(_onTvShowDetailsLoadRequested);
  }

  Future<void> _onMovieDetailsLoadRequested(
    MovieDetailsLoadRequested event,
    Emitter<DetailsState> emit,
  ) async {
    emit(DetailsLoading());
    try {
      final movie = await repository.fetchMovieDetails(event.movieId);
      emit(MovieDetailsLoaded(movie: movie));
    } catch (e) {
      emit(DetailsError(message: e.toString()));
    }
  }

  Future<void> _onTvShowDetailsLoadRequested(
    TvShowDetailsLoadRequested event,
    Emitter<DetailsState> emit,
  ) async {
    emit(DetailsLoading());
    try {
      final tvShow = await repository.fetchTvShowDetails(event.tvShowId);
      emit(TvShowDetailsLoaded(tvShow: tvShow));
    } catch (e) {
      emit(DetailsError(message: e.toString()));
    }
  }
}
