abstract class DetailsEvent {}

class MovieDetailsLoadRequested extends DetailsEvent {
  final String movieId;

  MovieDetailsLoadRequested({required this.movieId});
}

class TvShowDetailsLoadRequested extends DetailsEvent {
  final String tvShowId;

  TvShowDetailsLoadRequested({required this.tvShowId});
}
