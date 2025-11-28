// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/home/domain/entities/tv_show.dart';
import 'package:dester/features/home/domain/repository/home_repository.dart';

import 'get_tv_shows_list.dart';

class GetTVShowsListImpl implements GetTVShowsList {
  final HomeRepository repository;

  GetTVShowsListImpl(this.repository);

  @override
  Future<Result<List<TVShow>>> call() async {
    return await repository.getTVShows();
  }
}
