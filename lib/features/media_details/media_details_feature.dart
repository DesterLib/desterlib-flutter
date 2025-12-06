// Core
import 'package:dester/core/network/api_provider.dart';

// Dependency injection setup for MediaDetails feature
import 'data/datasources/media_details_datasource.dart';
import 'data/repository/media_details_repository_impl.dart';
import 'domain/usecases/get_movie_details.dart';
import 'domain/usecases/get_tv_show_details.dart';
import 'presentation/controllers/media_details_controller.dart';
import 'presentation/screens/s_media_details.dart';

class MediaDetailsFeature {
  // Singleton instances
  static MediaDetailsDatasource? _dataSource;
  static MediaDetailsRepositoryImpl? _repository;

  // Private helper to get or create data source
  static MediaDetailsDatasource _getDataSource() {
    _dataSource ??= MediaDetailsDatasource(api: ApiProvider.instance);
    return _dataSource!;
  }

  // Private helper to get or create repository
  static MediaDetailsRepositoryImpl _getRepository() {
    _repository ??= MediaDetailsRepositoryImpl(datasource: _getDataSource());
    return _repository!;
  }

  /// Override providers for MediaDetails feature with actual implementations
  // ignore: strict_top_level_inference
  static get overrides {
    // Use singleton instances
    final repository = _getRepository();

    // Use cases
    final getMovieDetails = GetMovieDetailsImpl(repository: repository);
    final getTVShowDetails = GetTVShowDetailsImpl(repository: repository);

    return [
      getMovieDetailsProvider.overrideWith((ref) => getMovieDetails),
      getTVShowDetailsProvider.overrideWith((ref) => getTVShowDetails),
    ];
  }

  static MediaDetailsScreen createMediaDetailsScreen({
    required String mediaId,
    required MediaType mediaType,
    String? initialTitle,
  }) {
    return MediaDetailsScreen(
      mediaId: mediaId,
      mediaType: mediaType,
      initialTitle: initialTitle,
    );
  }
}
