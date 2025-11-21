# openapi.model.ModelLibrary

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique library identifier | 
**name** | **String** | Library name | 
**slug** | **String** | URL-friendly library identifier | 
**description** | **String** | Library description | [optional] 
**posterUrl** | **String** | URL to the library poster image | [optional] 
**backdropUrl** | **String** | URL to the library backdrop image | [optional] 
**isLibrary** | **bool** | Whether this is a library (true) or collection (false) | 
**libraryPath** | **String** | File system path to the library | [optional] 
**libraryType** | **String** | Type of media in the library | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Library creation timestamp | 
**updatedAt** | [**DateTime**](DateTime.md) | Library last update timestamp | 
**parentId** | **String** | ID of parent library (for nested libraries) | [optional] 
**mediaCount** | **num** | Number of media items in the library | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


