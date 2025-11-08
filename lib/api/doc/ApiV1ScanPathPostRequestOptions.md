# openapi.model.ApiV1ScanPathPostRequestOptions

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**maxDepth** | **num** | Maximum directory depth to scan (0-10) | [optional] 
**mediaType** | **String** | Media type for TMDB API calls (movie or tv). Required for proper metadata fetching. | [optional] 
**fileExtensions** | **BuiltList&lt;String&gt;** | File extensions to include in the scan | [optional] [default to ListBuilder()]
**libraryName** | **String** | Name for the library. If not provided, uses \"Library - {path}\" | [optional] 
**rescan** | **bool** | If true, re-fetches metadata from TMDB even if it already exists in the database. If false or omitted, skips items that already have metadata. | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


