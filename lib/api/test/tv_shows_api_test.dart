import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for TVShowsApi
void main() {
  final instance = Openapi().getTVShowsApi();

  group(TVShowsApi, () {
    // Get all TV shows
    //
    // Retrieves all TV shows with their associated media metadata
    //
    //Future<ApiV1MoviesGet200Response> apiV1TvshowsGet() async
    test('test apiV1TvshowsGet', () async {
      // TODO
    });

  });
}
