# openapi.api.TVShowsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1TvshowsGet**](TVShowsApi.md#apiv1tvshowsget) | **GET** /api/v1/tvshows | Get all TV shows


# **apiV1TvshowsGet**
> ApiV1MoviesGet200Response apiV1TvshowsGet()

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

[**ApiV1MoviesGet200Response**](ApiV1MoviesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

