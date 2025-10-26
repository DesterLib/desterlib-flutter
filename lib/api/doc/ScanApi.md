# openapi.api.ScanApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1ScanPathPost**](ScanApi.md#apiv1scanpathpost) | **POST** /api/v1/scan/path | Scan a local file path and fetch TMDB metadata


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

