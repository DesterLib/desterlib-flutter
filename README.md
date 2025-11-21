# Dester

A Flutter application following Clean Architecture principles.

## Architecture

This project follows **Clean Architecture** with clear separation of concerns:

- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, repositories, and mappers
- **Presentation Layer**: UI components, screens, and state management

## Tech Stack

- **Flutter** ^3.10.0
- **Riverpod** ^3.0.3 (State Management)
- **GoRouter** ^17.0.0 (Navigation)
- **easy_localization** ^3.0.8 (i18n)
- **connectivity_plus** ^6.1.0 (Network monitoring)
- **http** ^1.2.2 (HTTP client)
- **shared_preferences** ^2.3.3 (Local storage)

## Project Structure

See [.cursorrules](.cursorrules) for detailed architecture documentation, conventions, and patterns.

## Features

- ✅ Clean Architecture implementation
- ✅ Riverpod state management
- ✅ GoRouter navigation
- ✅ Multi-language support (English, Spanish)
- ✅ Connection guard with platform-adaptive UI
- ✅ Local API URL configuration

## Getting Started

1. Install dependencies:

```bash
flutter pub get
```

2. Run the app:

```bash
flutter run
```

## Documentation

For detailed architecture, conventions, and development guidelines, see [.cursorrules](.cursorrules).
