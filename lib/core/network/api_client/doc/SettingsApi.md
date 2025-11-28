# openapi.api.SettingsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1SettingsFirstRunCompletePost**](SettingsApi.md#apiv1settingsfirstruncompletepost) | **POST** /api/v1/settings/first-run-complete | Complete first run setup
[**apiV1SettingsGet**](SettingsApi.md#apiv1settingsget) | **GET** /api/v1/settings | Get application settings
[**apiV1SettingsPut**](SettingsApi.md#apiv1settingsput) | **PUT** /api/v1/settings | Update application settings
[**apiV1SettingsResetPost**](SettingsApi.md#apiv1settingsresetpost) | **POST** /api/v1/settings/reset | Reset all settings to defaults
[**apiV1SettingsResetScanPost**](SettingsApi.md#apiv1settingsresetscanpost) | **POST** /api/v1/settings/reset-scan | Reset scan settings to defaults


# **apiV1SettingsFirstRunCompletePost**
> ApiV1SettingsFirstRunCompletePost200Response apiV1SettingsFirstRunCompletePost()

Complete first run setup

Mark the application's first run setup as completed

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();

try {
    final response = api.apiV1SettingsFirstRunCompletePost();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SettingsApi->apiV1SettingsFirstRunCompletePost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SettingsFirstRunCompletePost200Response**](ApiV1SettingsFirstRunCompletePost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SettingsGet**
> ApiV1SettingsGet200Response apiV1SettingsGet()

Get application settings

Retrieve current application settings (excludes sensitive data like jwtSecret)

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();

try {
    final response = api.apiV1SettingsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SettingsApi->apiV1SettingsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SettingsGet200Response**](ApiV1SettingsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SettingsPut**
> ApiV1SettingsPut200Response apiV1SettingsPut(updateSettingsRequest)

Update application settings

Update one or more application settings

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();
final UpdateSettingsRequest updateSettingsRequest = {"tmdbApiKey":"your-new-tmdb-api-key"}; // UpdateSettingsRequest | 

try {
    final response = api.apiV1SettingsPut(updateSettingsRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SettingsApi->apiV1SettingsPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateSettingsRequest** | [**UpdateSettingsRequest**](UpdateSettingsRequest.md)|  | 

### Return type

[**ApiV1SettingsPut200Response**](ApiV1SettingsPut200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SettingsResetPost**
> ApiV1SettingsResetPost200Response apiV1SettingsResetPost()

Reset all settings to defaults

Reset all application settings to their default values

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();

try {
    final response = api.apiV1SettingsResetPost();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SettingsApi->apiV1SettingsResetPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SettingsResetPost200Response**](ApiV1SettingsResetPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SettingsResetScanPost**
> ApiV1SettingsResetScanPost200Response apiV1SettingsResetScanPost()

Reset scan settings to defaults

Reset only the scan settings to their default values

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSettingsApi();

try {
    final response = api.apiV1SettingsResetScanPost();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SettingsApi->apiV1SettingsResetScanPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1SettingsResetScanPost200Response**](ApiV1SettingsResetScanPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

