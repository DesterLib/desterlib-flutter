# openapi.api.ScanApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1ScanCleanupPost**](ScanApi.md#apiv1scancleanuppost) | **POST** /api/v1/scan/cleanup | Cleanup stale scan jobs
[**apiV1ScanJobScanJobIdGet**](ScanApi.md#apiv1scanjobscanjobidget) | **GET** /api/v1/scan/job/{scanJobId} | Get scan job status
[**apiV1ScanPathPost**](ScanApi.md#apiv1scanpathpost) | **POST** /api/v1/scan/path | Scan a local file path and fetch TMDB metadata
[**apiV1ScanResumeScanJobIdPost**](ScanApi.md#apiv1scanresumescanjobidpost) | **POST** /api/v1/scan/resume/{scanJobId} | Resume a failed or paused scan job


# **apiV1ScanCleanupPost**
> ApiV1ScanCleanupPost200Response apiV1ScanCleanupPost()

Cleanup stale scan jobs

Manually trigger cleanup of scan jobs that have been stuck in IN_PROGRESS state. Useful after API crashes or unexpected shutdowns. 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getScanApi();

try {
    final response = api.apiV1ScanCleanupPost();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ScanApi->apiV1ScanCleanupPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1ScanCleanupPost200Response**](ApiV1ScanCleanupPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ScanJobScanJobIdGet**
> apiV1ScanJobScanJobIdGet(scanJobId)

Get scan job status

Get detailed status information about a scan job

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getScanApi();
final String scanJobId = scanJobId_example; // String | 

try {
    api.apiV1ScanJobScanJobIdGet(scanJobId);
} catch on DioException (e) {
    print('Exception when calling ScanApi->apiV1ScanJobScanJobIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scanJobId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ScanPathPost**
> ApiV1ScanPathPost200Response apiV1ScanPathPost(apiV1ScanPathPostRequest)

Scan a local file path and fetch TMDB metadata

Scans a local directory path and returns discovered media files with TMDB metadata. - Automatically fetches metadata from TMDB using the API key from environment variables - Extracts IDs from filenames and folder names (supports {tmdb-XXX}, {imdb-ttXXX}, {tvdb-XXX} formats) - Stores media information in the database with proper relationships - Supports both movies and TV shows 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getScanApi();
final ApiV1ScanPathPostRequest apiV1ScanPathPostRequest = ; // ApiV1ScanPathPostRequest | 

try {
    final response = api.apiV1ScanPathPost(apiV1ScanPathPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ScanApi->apiV1ScanPathPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1ScanPathPostRequest** | [**ApiV1ScanPathPostRequest**](ApiV1ScanPathPostRequest.md)|  | 

### Return type

[**ApiV1ScanPathPost200Response**](ApiV1ScanPathPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ScanResumeScanJobIdPost**
> ApiV1ScanResumeScanJobIdPost202Response apiV1ScanResumeScanJobIdPost(scanJobId)

Resume a failed or paused scan job

Resumes a scan job that was previously paused or failed. - Continues processing from where it left off - Only processes remaining unscanned folders - Sends progress updates via WebSocket 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getScanApi();
final String scanJobId = clxxxx1234567890abcdefgh; // String | The ID of the scan job to resume

try {
    final response = api.apiV1ScanResumeScanJobIdPost(scanJobId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ScanApi->apiV1ScanResumeScanJobIdPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scanJobId** | **String**| The ID of the scan job to resume | 

### Return type

[**ApiV1ScanResumeScanJobIdPost202Response**](ApiV1ScanResumeScanJobIdPost202Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

