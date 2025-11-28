// Core
import 'package:dester/core/errors/errors.dart';

// Features
import 'package:dester/features/home/domain/entities/tv_show.dart';

abstract class GetTVShowsList {
  Future<Result<List<TVShow>>> call();
}
