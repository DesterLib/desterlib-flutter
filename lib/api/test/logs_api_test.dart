import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for LogsApi
void main() {
  final instance = Openapi().getLogsApi();

  group(LogsApi, () {
    // Clear all logs
    //
    // Clears all log entries from the server
    //
    //Future<ApiV1LogsDelete200Response> apiV1LogsDelete() async
    test('test apiV1LogsDelete', () async {
      // TODO
    });

    // Get recent API logs
    //
    // Fetches recent log entries from the server with optional filtering
    //
    //Future<ApiV1LogsGet200Response> apiV1LogsGet({ num limit, String level }) async
    test('test apiV1LogsGet', () async {
      // TODO
    });

  });
}
