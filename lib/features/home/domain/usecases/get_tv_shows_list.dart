// Features
import 'package:dester/features/home/domain/entities/tv_show.dart';


abstract class GetTVShowsList {
  Future<List<TVShow>> call();
}
