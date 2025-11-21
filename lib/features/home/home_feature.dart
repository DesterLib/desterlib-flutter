// Dependency injection setup for Home feature
import 'data/datasources/home_datasource.dart';
import 'data/repository/home_repository_impl.dart';
import 'domain/usecases/get_movies_list_impl.dart';
import 'domain/usecases/get_tv_shows_list_impl.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/screens/home_screen.dart';

class HomeFeature {
  static HomeScreen createHomeScreen() {
    // Data source
    final dataSource = HomeDataSource();

    // Repository
    final repository = HomeRepositoryImpl(dataSource: dataSource);

    // Use cases
    final getMoviesList = GetMoviesListImpl(repository);
    final getTVShowsList = GetTVShowsListImpl(repository);

    // Controller
    final controller = HomeController(
      getMoviesList: getMoviesList,
      getTVShowsList: getTVShowsList,
    );

    // Screen
    return HomeScreen(controller: controller);
  }
}
