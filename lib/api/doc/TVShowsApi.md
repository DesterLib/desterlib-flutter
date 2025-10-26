# openapi.api.TVShowsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1TvshowsGet**](TVShowsApi.md#apiv1tvshowsget) | **GET** /api/v1/tvshows | Get all TV shows
[**apiV1TvshowsIdGet**](TVShowsApi.md#apiv1tvshowsidget) | **GET** /api/v1/tvshows/{id} | Get a TV show by ID


# **apiV1TvshowsGet**
> BuiltList<ApiV1TvshowsGet200ResponseInner> apiV1TvshowsGet()

Get all TV shows

Retrieves all TV shows with their associated media metadata

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTVShowsApi();

try {
    final response = api.apiV1TvshowsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling TVShowsApi->apiV1TvshowsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ApiV1TvshowsGet200ResponseInner&gt;**](ApiV1TvshowsGet200ResponseInner.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1TvshowsIdGet**
> ApiV1TvshowsGet200ResponseInner apiV1TvshowsIdGet(id)

Get a TV show by ID

Retrieves a single TV show with its associated media metadata

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTVShowsApi();
final String id = clx123abc456def789; // String | The TV show ID

try {
    final response = api.apiV1TvshowsIdGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TVShowsApi->apiV1TvshowsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The TV show ID | 

### Return type

[**ApiV1TvshowsGet200ResponseInner**](ApiV1TvshowsGet200ResponseInner.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

