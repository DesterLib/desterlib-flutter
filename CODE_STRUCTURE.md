# Dester - Code Structure

> **Architecture**: Feature-First with Clean Architecture + Riverpod for state management

This structure is optimized for scalability, testability, and Riverpod's dependency injection pattern.

```
lib/
├─ app/ ← root-level app wiring (themes, routes, global providers, bootstrap)
│  ├─ app.dart ← wraps app with ProviderScope, like _app.tsx in Next.js
│  ├─ providers.dart ← global app-level providers (Riverpod IS the DI)
│  ├─ router.dart ← all routes/screens (can use riverpod_router_go)
│  └─ theme/ ← custom design system / Tailwind-lite (themeProvider here)
│
├─ core/ ← fundamental building blocks (pure, reusable across ALL FEATURES)
│  ├─ config/ ← constants, envs, API base URLs, secrets (environment providers)
│  ├─ errors/ ← custom AppFailure, APIError, NetworkException classes
│  ├─ utils/ ← pure helpers, formatters, debouncers, logging (no state)
│  └─ services/ ← lightweight services (storage, analytics) + their providers
│
├─ shared/ ← DROP-IN UI & logic used everywhere (like /components + /lib/utils)
│  ├─ widgets/ ← Consumer widgets (buttons, nav, players, loaders, snackbars)
│  ├─ hooks/ ← custom hooks (if using flutter_hooks + hooks_riverpod)
│  ├─ animations/ ← framer-motion equivalents (implicitly animated widgets)
│  └─ responsive/ ← Layout builder (mobile/tablet/desktop/tv awareness)
│
├─ features/ ← each feature = isolated mini-application (THIS IS WHERE 80% WORK HAPPENS)
│  ├─ auth/
│  │  ├─ data/ ← API clients, models/DTOs, repository implementations
│  │  ├─ domain/ ← entities, abstract repository interfaces, usecases
│  │  ├─ presentation/ ← screens, widgets, Notifier/AsyncNotifier providers
│  │  │  ├─ providers/ ← feature-specific state (authController, userProvider)
│  │  │  ├─ screens/ ← login_screen.dart, register_screen.dart
│  │  │  └─ widgets/ ← feature-specific UI components
│  │  └─ auth_feature.dart ← export barrel for this feature
│  ├─ library/ ← media browsing feature
│  ├─ playback/ ← player UI + physics-layers + controls
│  └─ settings/
│
└─ main.dart ← Flutter entrypoint: runApp(ProviderScope(child: App()))
```

## Key Principles

- **Riverpod replaces traditional DI**: No GetIt, no InheritedWidget gymnastics
- **Feature isolation**: Each feature is self-contained with its own data/domain/presentation
- **Shared components**: Reusable UI lives in `shared/`, business logic in `core/`
- **Provider colocation**: Keep providers close to where they're used (feature-level)
