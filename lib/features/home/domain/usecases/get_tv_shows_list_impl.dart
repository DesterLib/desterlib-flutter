import '../entities/tv_show.dart';
import '../repository/home_repository.dart';
import 'get_tv_shows_list.dart';

class GetTVShowsListImpl implements GetTVShowsList {
  final HomeRepository repository;

  GetTVShowsListImpl(this.repository);

  @override
  Future<List<TVShow>> call() async {
    return await repository.getTVShows();
  }
}
