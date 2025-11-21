# openapi.api.StreamApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1StreamIdGet**](StreamApi.md#apiv1streamidget) | **GET** /api/v1/stream/{id} | Stream any media file by ID with byte-range support


# **apiV1StreamIdGet**
> apiV1StreamIdGet(id, range)

Stream any media file by ID with byte-range support

Streams any media file (movie, TV episode, music, comic) with proper HTTP range request support. This centralized endpoint can handle any media type stored in the database. Supports seeking, partial content delivery, and proper streaming headers for video/audio playback. 

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getStreamApi();
final String id = clx123abc456def789; // String | The media file ID (can be movie ID, episode ID, music ID, or comic ID)
final String range = bytes=0-1048576; // String | Byte range request (e.g., \"bytes=0-1023\")

try {
    api.apiV1StreamIdGet(id, range);
} catch on DioException (e) {
    print('Exception when calling StreamApi->apiV1StreamIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| The media file ID (can be movie ID, episode ID, music ID, or comic ID) | 
 **range** | **String**| Byte range request (e.g., \"bytes=0-1023\") | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

