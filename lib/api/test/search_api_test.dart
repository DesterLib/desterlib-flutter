import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SearchApi
void main() {
  final instance = Openapi().getSearchApi();

  group(SearchApi, () {
    // Search media by title
    //
    // Searches for movies and TV shows by title (case-insensitive). Returns matching movies and TV shows with their media metadata. 
    //
    //Future<ApiV1SearchGet200Response> apiV1SearchGet(String query) async
    test('test apiV1SearchGet', () async {
      // TODO
    });

  });
}
