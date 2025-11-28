// Dependency injection setup for Home feature
import 'data/datasources/home_datasource.dart';
import 'data/repository/home_repository_impl.dart';
import 'domain/usecases/get_movies_list_impl.dart';
import 'domain/usecases/get_tv_shows_list_impl.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/screens/s_home.dart';

class HomeFeature {
  /// Override providers for Home feature with actual implementations
  // ignore: strict_top_level_inference
  static get overrides {
    // Data source
    final dataSource = HomeDataSource();

    // Repository
    final repository = HomeRepositoryImpl(dataSource: dataSource);

    // Use cases
    final getMoviesList = GetMoviesListImpl(repository);
    final getTVShowsList = GetTVShowsListImpl(repository);

    return [
      getMoviesListProvider.overrideWith((ref) => getMoviesList),
      getTVShowsListProvider.overrideWith((ref) => getTVShowsList),
    ];
  }

  static HomeScreen createHomeScreen() {
    // Screen uses providers directly via ConsumerWidget
    return const HomeScreen();
  }
}
