import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for HealthApi
void main() {
  final instance = Openapi().getHealthApi();

  group(HealthApi, () {
    // Health check endpoint
    //
    // Returns the current status of the API including version information
    //
    //Future<HealthResponse> healthGet() async
    test('test healthGet', () async {
      // TODO
    });

  });
}
