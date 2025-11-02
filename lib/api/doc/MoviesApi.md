# openapi.api.MoviesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1MoviesGet**](MoviesApi.md#apiv1moviesget) | **GET** /api/v1/movies | Get all movies


# **apiV1MoviesGet**
> ApiV1MoviesGet200Response apiV1MoviesGet()

Get all movies

Retrieves all movies with their associated media metadata

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getMoviesApi();

try {
    final response = api.apiV1MoviesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling MoviesApi->apiV1MoviesGet: $e\n');
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

