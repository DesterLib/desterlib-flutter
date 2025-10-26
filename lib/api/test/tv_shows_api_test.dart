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
    //Future<BuiltList<ApiV1TvshowsGet200ResponseInner>> apiV1TvshowsGet() async
    test('test apiV1TvshowsGet', () async {
      // TODO
    });

    // Get a TV show by ID
    //
    // Retrieves a single TV show with its associated media metadata
    //
    //Future<ApiV1TvshowsGet200ResponseInner> apiV1TvshowsIdGet(String id) async
    test('test apiV1TvshowsIdGet', () async {
      // TODO
    });

  });
}
