# openapi.api.LogsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1LogsDelete**](LogsApi.md#apiv1logsdelete) | **DELETE** /api/v1/logs | Clear all logs
[**apiV1LogsGet**](LogsApi.md#apiv1logsget) | **GET** /api/v1/logs | Get recent API logs


# **apiV1LogsDelete**
> ApiV1LogsDelete200Response apiV1LogsDelete()

Clear all logs

Clears all log entries from the server

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLogsApi();

try {
    final response = api.apiV1LogsDelete();
    print(response);
} catch on DioException (e) {
    print('Exception when calling LogsApi->apiV1LogsDelete: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1LogsDelete200Response**](ApiV1LogsDelete200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1LogsGet**
> ApiV1LogsGet200Response apiV1LogsGet(limit, level)

Get recent API logs

Fetches recent log entries from the server with optional filtering

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLogsApi();
final num limit = 8.14; // num | Number of logs to retrieve
final String level = level_example; // String | Filter by log level

try {
    final response = api.apiV1LogsGet(limit, level);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LogsApi->apiV1LogsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**| Number of logs to retrieve | [optional] [default to 100]
 **level** | **String**| Filter by log level | [optional] 

### Return type

[**ApiV1LogsGet200Response**](ApiV1LogsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

