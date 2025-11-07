# openapi.api.SearchApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1SearchGet**](SearchApi.md#apiv1searchget) | **GET** /api/v1/search | Search media by title


# **apiV1SearchGet**
> ApiV1SearchGet200Response apiV1SearchGet(query)

Search media by title

Searches for movies and TV shows by title (case-insensitive). Returns matching movies and TV shows with their media metadata. 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSearchApi();
final String query = matrix; // String | Search query string

try {
    final response = api.apiV1SearchGet(query);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SearchApi->apiV1SearchGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**| Search query string | 

### Return type

[**ApiV1SearchGet200Response**](ApiV1SearchGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

