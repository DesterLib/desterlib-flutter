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

    // Get a movie by ID
    //
    // Retrieves a single movie with its associated media metadata
    //
    //Future<ApiV1MoviesIdGet200Response> apiV1MoviesIdGet(String id) async
    test('test apiV1MoviesIdGet', () async {
      // TODO
    });

  });
}
