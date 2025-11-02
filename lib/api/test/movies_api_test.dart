import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for MoviesApi
void main() {
  final instance = Openapi().getMoviesApi();

  group(MoviesApi, () {
    // Get all movies
    //
    // Retrieves all movies with their associated media metadata
    //
    //Future<ApiV1MoviesGet200Response> apiV1MoviesGet() async
    test('test apiV1MoviesGet', () async {
      // TODO
    });

  });
}
