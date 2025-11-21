import 'package:flutter/foundation.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/usecases/get_movies_list_impl.dart';
import '../../domain/usecases/get_tv_shows_list_impl.dart';

class HomeController extends ChangeNotifier {
  final GetMoviesListImpl getMoviesList;
  final GetTVShowsListImpl getTVShowsList;

  HomeController({required this.getMoviesList, required this.getTVShowsList});

  List<Movie> _movies = [];
  List<TVShow> _tvShows = [];
  bool _isLoadingMovies = false;
  bool _isLoadingTVShows = false;
  String? _moviesError;
  String? _tvShowsError;

  List<Movie> get movies => _movies;
  List<TVShow> get tvShows => _tvShows;
  bool get isLoadingMovies => _isLoadingMovies;
  bool get isLoadingTVShows => _isLoadingTVShows;
  String? get moviesError => _moviesError;
  String? get tvShowsError => _tvShowsError;

  Future<void> loadMovies() async {
    _isLoadingMovies = true;
    _moviesError = null;
    notifyListeners();

    try {
      _movies = await getMoviesList();
      _moviesError = null;
    } catch (e) {
      _moviesError = e.toString();
      _movies = [];
    } finally {
      _isLoadingMovies = false;
      notifyListeners();
    }
  }

  Future<void> loadTVShows() async {
    _isLoadingTVShows = true;
    _tvShowsError = null;
    notifyListeners();

    try {
      _tvShows = await getTVShowsList();
      _tvShowsError = null;
    } catch (e) {
      _tvShowsError = e.toString();
      _tvShows = [];
    } finally {
      _isLoadingTVShows = false;
      notifyListeners();
    }
  }

  Future<void> loadAll() async {
    await Future.wait([loadMovies(), loadTVShows()]);
  }
}
