# DesterLib API Client

Simple, clean API client for DesterLib - no code generation, just plain Dart! 🚀

## Quick Start

```dart
import 'package:dester/core/network/dester_api.dart';

// Create API instance
final api = DesterApi(
  baseUrl: 'http://localhost:3000',
  timeout: Duration(seconds: 30),
);

// Use it!
try {
  // Get settings
  final settings = await api.settings.getSettings();
  print('Port: ${settings.port}');

  // Update settings
  await api.settings.updateSettings(
    UpdateSettingsRequestDto(
      scanSettings: ScanSettingsDto(
        rescan: false,
        followSymlinks: true,
        mediaTypeDepth: MediaTypeDepthDto(movie: 2, tv: 4),
      ),
    ),
  );

  // Complete first run
  await api.settings.completeFirstRun();

} on ApiException catch (e) {
  print('API Error: ${e.message} (${e.statusCode})');
} catch (e) {
  print('Error: $e');
}

// Clean up when done
api.dispose();
```

## Architecture

```
lib/core/network/
├── dester_api.dart          # Main API entry point
├── api_client.dart          # Dio HTTP client wrapper
├── api_exception.dart       # Exception handling
├── api/                     # API endpoint implementations
│   └── settings_api.dart
├── models/                  # Simple DTO classes (no code generation!)
│   ├── api_response.dart
│   └── settings_models.dart
└── mappers/                 # Convert DTOs to domain entities
    └── settings_mapper.dart
```

## Benefits

- ✅ **Simple**: Plain Dart classes, easy to understand
- ✅ **No Code Generation**: No freezed, no build_runner complexity
- ✅ **Type Safe**: Full compile-time type checking
- ✅ **Clean Errors**: Structured exception handling
- ✅ **Easy to Debug**: No generated code to wade through
- ✅ **Fast**: No build step required

## Adding New Endpoints

1. Create model DTOs in `models/`
2. Create API class in `api/`
3. Add to `DesterApi` class
4. Done! No code generation needed.
