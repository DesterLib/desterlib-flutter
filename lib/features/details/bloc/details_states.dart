import '../models/movie_details.dart';
import '../models/tvshow_details.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class MovieDetailsLoaded extends DetailsState {
  final MovieDetails movie;

  MovieDetailsLoaded({required this.movie});
}

class TvShowDetailsLoaded extends DetailsState {
  final TvShowDetails tvShow;

  TvShowDetailsLoaded({required this.tvShow});
}

class DetailsError extends DetailsState {
  final String message;

  DetailsError({required this.message});
}
