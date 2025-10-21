import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_events.dart';
import 'settings_states.dart';
import '../repo/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(SettingsLoading()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<SettingsRefreshRequested>(_onRefreshRequested);
    on<LibraryCreateRequested>(_onCreateRequested);
    on<LibraryUpdateRequested>(_onUpdateRequested);
    on<LibraryDeleteRequested>(_onDeleteRequested);
    on<LibraryScanRequested>(_onScanRequested);
    on<AppSettingsUpdateRequested>(_onAppSettingsUpdateRequested);
  }

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final libraries = await repository.fetchLibraries();
      final appSettings = await repository.fetchSettings();
      emit(SettingsLoaded(libraries: libraries, appSettings: appSettings));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    SettingsRefreshRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final libraries = await repository.fetchLibraries();
      final appSettings = await repository.fetchSettings();
      emit(SettingsLoaded(libraries: libraries, appSettings: appSettings));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    LibraryCreateRequested event,
    Emitter<SettingsState> emit,
  ) async {
    // Get current state
    final currentState = state;
    final currentLibraries = currentState is SettingsLoaded
        ? currentState.libraries
        : <Library>[];
    final currentAppSettings = currentState is SettingsLoaded
        ? currentState.appSettings
        : AppSettings();

    emit(
      SettingsOperationInProgress(
        libraries: currentLibraries,
        appSettings: currentAppSettings,
        operation: 'Creating library...',
      ),
    );

    try {
      // Create library and start scan (scan endpoint auto-creates the library)
      final result = await repository.createLibrary(
        name: event.name,
        path: event.path,
        type: event.type,
      );

      // Refresh libraries to show the new one
      final libraries = await repository.fetchLibraries();
      final appSettings = await repository.fetchSettings();
      emit(
        SettingsOperationSuccess(
          libraries: libraries,
          appSettings: appSettings,
          message:
              result['message'] ??
              'Library created and scan started successfully',
        ),
      );

      // Auto-transition to loaded state after a short delay
      await Future.delayed(const Duration(seconds: 2));
      emit(SettingsLoaded(libraries: libraries, appSettings: appSettings));
    } catch (e) {
      emit(SettingsError(message: 'Failed to create library: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateRequested(
    LibraryUpdateRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentLibraries = currentState is SettingsLoaded
        ? currentState.libraries
        : <Library>[];
    final currentAppSettings = currentState is SettingsLoaded
        ? currentState.appSettings
        : AppSettings();

    emit(
      SettingsOperationInProgress(
        libraries: currentLibraries,
        appSettings: currentAppSettings,
        operation: 'Updating library...',
      ),
    );

    try {
      await repository.updateLibrary(
        id: event.id,
        name: event.name,
        path: event.path,
        type: event.type,
      );

      final libraries = await repository.fetchLibraries();
      final appSettings = await repository.fetchSettings();
      emit(
        SettingsOperationSuccess(
          libraries: libraries,
          appSettings: appSettings,
          message: 'Library updated successfully',
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      emit(SettingsLoaded(libraries: libraries, appSettings: appSettings));
    } catch (e) {
      emit(SettingsError(message: 'Failed to update library: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteRequested(
    LibraryDeleteRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentLibraries = currentState is SettingsLoaded
        ? currentState.libraries
        : <Library>[];
    final currentAppSettings = currentState is SettingsLoaded
        ? currentState.appSettings
        : AppSettings();

    emit(
      SettingsOperationInProgress(
        libraries: currentLibraries,
        appSettings: currentAppSettings,
        operation: 'Deleting library...',
      ),
    );

    try {
      await repository.deleteLibrary(event.id);

      final libraries = await repository.fetchLibraries();
      final appSettings = await repository.fetchSettings();
      emit(
        SettingsOperationSuccess(
          libraries: libraries,
          appSettings: appSettings,
          message: 'Library deleted successfully',
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      emit(SettingsLoaded(libraries: libraries, appSettings: appSettings));
    } catch (e) {
      emit(SettingsError(message: 'Failed to delete library: ${e.toString()}'));
    }
  }

  Future<void> _onScanRequested(
    LibraryScanRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentLibraries = currentState is SettingsLoaded
        ? currentState.libraries
        : <Library>[];
    final currentAppSettings = currentState is SettingsLoaded
        ? currentState.appSettings
        : AppSettings();

    emit(
      SettingsOperationInProgress(
        libraries: currentLibraries,
        appSettings: currentAppSettings,
        operation: 'Starting scan...',
      ),
    );

    try {
      await repository.scanLibrary(event.libraryId);

      emit(
        SettingsOperationSuccess(
          libraries: currentLibraries,
          appSettings: currentAppSettings,
          message: 'Scan started successfully',
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      emit(
        SettingsLoaded(
          libraries: currentLibraries,
          appSettings: currentAppSettings,
        ),
      );
    } catch (e) {
      emit(SettingsError(message: 'Failed to start scan: ${e.toString()}'));
    }
  }

  Future<void> _onAppSettingsUpdateRequested(
    AppSettingsUpdateRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentLibraries = currentState is SettingsLoaded
        ? currentState.libraries
        : <Library>[];
    final currentAppSettings = currentState is SettingsLoaded
        ? currentState.appSettings
        : AppSettings();

    emit(
      SettingsOperationInProgress(
        libraries: currentLibraries,
        appSettings: currentAppSettings,
        operation: 'Updating settings...',
      ),
    );

    try {
      final appSettings = await repository.updateSettings(
        tmdbApiKey: event.tmdbApiKey,
        port: event.port,
        enableRouteGuards: event.enableRouteGuards,
      );

      emit(
        SettingsOperationSuccess(
          libraries: currentLibraries,
          appSettings: appSettings,
          message: 'Settings updated successfully',
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      emit(
        SettingsLoaded(libraries: currentLibraries, appSettings: appSettings),
      );
    } catch (e) {
      emit(
        SettingsError(message: 'Failed to update settings: ${e.toString()}'),
      );
    }
  }
}
