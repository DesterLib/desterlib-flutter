import 'package:equatable/equatable.dart';
import '../repo/home_repository.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieItem> movies;
  final List<TvItem> tvShows;

  HomeLoaded({required this.movies, required this.tvShows});

  @override
  List<Object> get props => [movies, tvShows];
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
