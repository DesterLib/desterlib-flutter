# openapi.api.LibraryApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1LibraryDelete**](LibraryApi.md#apiv1librarydelete) | **DELETE** /api/v1/library | Delete a library and its associated media
[**apiV1LibraryGet**](LibraryApi.md#apiv1libraryget) | **GET** /api/v1/library | Get all libraries with optional filtering
[**apiV1LibraryPut**](LibraryApi.md#apiv1libraryput) | **PUT** /api/v1/library | Update library details


# **apiV1LibraryDelete**
> ApiV1LibraryDelete200Response apiV1LibraryDelete(apiV1LibraryDeleteRequest)

Delete a library and its associated media

Deletes a library: - Removes the library structure and metadata from the database - Deletes all media entries that ONLY belong to this library - Keeps media that also belongs to other libraries - Does NOT delete actual files on disk (prevents accidental data loss) - Cascade deletes related data (genres, persons, external IDs, etc.) 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLibraryApi();
final ApiV1LibraryDeleteRequest apiV1LibraryDeleteRequest = ; // ApiV1LibraryDeleteRequest | 

try {
    final response = api.apiV1LibraryDelete(apiV1LibraryDeleteRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LibraryApi->apiV1LibraryDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1LibraryDeleteRequest** | [**ApiV1LibraryDeleteRequest**](ApiV1LibraryDeleteRequest.md)|  | 

### Return type

[**ApiV1LibraryDelete200Response**](ApiV1LibraryDelete200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1LibraryGet**
> ApiV1LibraryGet200Response apiV1LibraryGet(isLibrary, libraryType)

Get all libraries with optional filtering

Retrieves a list of libraries with optional filtering by: - isLibrary: Filter by actual libraries vs collections - libraryType: Filter by media type (MOVIE, TV_SHOW, MUSIC, COMIC) 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLibraryApi();
final bool isLibrary = true; // bool | Filter by actual libraries (true) vs collections (false)
final String libraryType = MOVIE; // String | Filter by library media type

try {
    final response = api.apiV1LibraryGet(isLibrary, libraryType);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LibraryApi->apiV1LibraryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **isLibrary** | **bool**| Filter by actual libraries (true) vs collections (false) | [optional] 
 **libraryType** | **String**| Filter by library media type | [optional] 

### Return type

[**ApiV1LibraryGet200Response**](ApiV1LibraryGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1LibraryPut**
> ApiV1LibraryPut200Response apiV1LibraryPut(apiV1LibraryPutRequest)

Update library details

Updates library metadata including name, description, URLs, and settings. Empty string values for optional fields will be set to null. 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getLibraryApi();
final ApiV1LibraryPutRequest apiV1LibraryPutRequest = ; // ApiV1LibraryPutRequest | 

try {
    final response = api.apiV1LibraryPut(apiV1LibraryPutRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LibraryApi->apiV1LibraryPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1LibraryPutRequest** | [**ApiV1LibraryPutRequest**](ApiV1LibraryPutRequest.md)|  | 

### Return type

[**ApiV1LibraryPut200Response**](ApiV1LibraryPut200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

