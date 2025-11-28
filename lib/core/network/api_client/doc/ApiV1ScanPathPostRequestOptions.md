# openapi.model.ApiV1ScanPathPostRequestOptions

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**mediaType** | **String** | Type of media to scan (movie or tv). Required for proper metadata fetching. Defaults to database settings if not provided, or \"movie\" if no database setting exists.  | [optional] [default to 'movie']
**mediaTypeDepth** | [**ApiV1ScanPathPostRequestOptionsMediaTypeDepth**](ApiV1ScanPathPostRequestOptionsMediaTypeDepth.md) |  | [optional] 
**filenamePattern** | **String** | Regex pattern to match filenames. Only files matching this pattern will be scanned. Example: '^.*S\\\\d{2}E\\\\d{2}.*$' for episode files (S01E01, S02E05, etc.) Defaults to database settings if not provided. If not set in database, all files matching video extensions are scanned.  | [optional] 
**directoryPattern** | **String** | Regex pattern to match directory names. Only directories matching this pattern will be scanned. Useful for specific folder structures (e.g., \"^Season \\\\d+$\" to only scan Season folders). Defaults to database settings if not provided. If not set in database, all directories are scanned.  | [optional] 
**rescan** | **bool** | If true, re-fetches metadata even if it already exists in the database. If false, skips items that already have metadata. Defaults to database settings if not provided, or false if no database setting exists.  | [optional] 
**batchScan** | **bool** | Enable batch scanning mode for large libraries. Automatically enabled for TV shows. Batches: 5 shows or 25 movies per batch. Useful for slow storage (FTP, SMB, etc.) Defaults to database settings if not provided, or false if no database setting exists.  | [optional] 
**followSymlinks** | **bool** | Whether to follow symbolic links during scanning. Defaults to database settings if not provided, or true if no database setting exists.  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


