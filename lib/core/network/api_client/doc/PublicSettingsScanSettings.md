# openapi.model.PublicSettingsScanSettings

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**mediaType** | **String** | Type of media to scan (movie or tv) | [optional] 
**maxDepth** | **num** | Maximum directory depth to scan | [optional] 
**mediaTypeDepth** | [**PublicSettingsScanSettingsMediaTypeDepth**](PublicSettingsScanSettingsMediaTypeDepth.md) |  | [optional] 
**fileExtensions** | **BuiltList&lt;String&gt;** | File extensions to include in the scan | [optional] 
**filenamePattern** | **String** | Regex pattern to match filenames | [optional] 
**excludePattern** | **String** | Regex pattern to exclude files/directories | [optional] 
**includePattern** | **String** | Regex pattern to include files/directories | [optional] 
**directoryPattern** | **String** | Regex pattern to match directory names | [optional] 
**excludeDirectories** | **BuiltList&lt;String&gt;** | List of directory names to exclude | [optional] 
**includeDirectories** | **BuiltList&lt;String&gt;** | List of directory names to include | [optional] 
**rescan** | **bool** | Re-fetch metadata even if it already exists | [optional] 
**batchScan** | **bool** | Enable batch scanning mode for large libraries | [optional] 
**minFileSize** | **num** | Minimum file size in bytes | [optional] 
**maxFileSize** | **num** | Maximum file size in bytes | [optional] 
**followSymlinks** | **bool** | Whether to follow symbolic links during scanning | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


