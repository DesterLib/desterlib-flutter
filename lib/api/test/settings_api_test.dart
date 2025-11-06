import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SettingsApi
void main() {
  final instance = Openapi().getSettingsApi();

  group(SettingsApi, () {
    // Complete first run setup
    //
    // Mark the application's first run setup as completed
    //
    //Future<ApiV1SettingsFirstRunCompletePost200Response> apiV1SettingsFirstRunCompletePost() async
    test('test apiV1SettingsFirstRunCompletePost', () async {
      // TODO
    });

    // Get application settings
    //
    // Retrieve current application settings (excludes sensitive data like jwtSecret)
    //
    //Future<ApiV1SettingsGet200Response> apiV1SettingsGet() async
    test('test apiV1SettingsGet', () async {
      // TODO
    });

    // Update application settings
    //
    // Update one or more application settings
    //
    //Future<ApiV1SettingsPut200Response> apiV1SettingsPut(UpdateSettingsRequest updateSettingsRequest) async
    test('test apiV1SettingsPut', () async {
      // TODO
    });

  });
}
