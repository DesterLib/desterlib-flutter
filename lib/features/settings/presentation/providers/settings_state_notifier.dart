// External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';

/// AsyncNotifier for managing settings state reactively
/// Provides local-first updates with automatic background sync
class SettingsNotifier extends AsyncNotifier<Settings> {
  SettingsRepository? _repository;

  /// Set repository (called when repository is ready)
  void setRepository(SettingsRepository repository) {
    _repository = repository;
    // Reload settings with new repository
    _refresh();
  }

  /// Refresh the settings state by rebuilding
  Future<void> _refresh() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await build());
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  @override
  Future<Settings> build() async {
    // If repository is not set yet, return default settings
    // This will be updated when repository is ready
    if (_repository == null) {
      AppLogger.w('Settings repository not initialized, using defaults');
      return const Settings(firstRun: true);
    }

    try {
      final result = await _repository!.getSettings();
      return result.fold(
        onSuccess: (settings) {
          AppLogger.d('Settings loaded successfully');
          return settings;
        },
        onFailure: (failure) {
          AppLogger.e('Failed to load settings: ${failure.message}');
          throw failure;
        },
      );
    } catch (e, stack) {
      AppLogger.e('Exception loading settings: $e', stack);
      rethrow;
    }
  }

  /// Update a single setting field
  /// Updates local cache immediately, syncs in background
  Future<void> updateField({
    String? tmdbApiKey,
    ScanSettings? scanSettings,
  }) async {
    if (_repository == null) {
      AppLogger.w('Cannot update settings: repository not initialized');
      return;
    }

    // Get current state - use pattern matching to safely extract value
    final current = state.maybeWhen(data: (value) => value, orElse: () => null);

    if (current == null) {
      AppLogger.w('Cannot update settings: no current state');
      return;
    }

    // Optimistically update state
    final updated = Settings(
      tmdbApiKey: tmdbApiKey ?? current.tmdbApiKey,
      firstRun: current.firstRun,
      scanSettings: scanSettings ?? current.scanSettings,
    );
    state = AsyncValue.data(updated);

    // Update in background
    try {
      final result = await _repository!.updateSettings(
        tmdbApiKey: tmdbApiKey,
        scanSettings: scanSettings,
      );
      result.fold(
        onSuccess: (settings) {
          // Update state with server response
          state = AsyncValue.data(settings);
          AppLogger.d('Settings updated successfully');
        },
        onFailure: (failure) {
          // On failure, reload to get correct state
          // The repository should have cached the optimistic update
          AppLogger.w('Settings update failed: ${failure.message}, reloading');
          _refresh();
        },
      );
    } catch (e, stack) {
      AppLogger.e('Exception updating settings: $e', stack);
      // On exception, reload
      _refresh();
    }
  }

  /// Reset all settings
  Future<void> resetAll() async {
    if (_repository == null) {
      AppLogger.w('Cannot reset settings: repository not initialized');
      return;
    }

    state = const AsyncValue.loading();
    try {
      final result = await _repository!.resetAllSettings();
      result.fold(
        onSuccess: (settings) {
          state = AsyncValue.data(settings);
          AppLogger.d('All settings reset successfully');
        },
        onFailure: (failure) {
          state = AsyncValue.error(failure, StackTrace.current);
          AppLogger.e('Failed to reset all settings: ${failure.message}');
        },
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.e('Exception resetting all settings: $e', stack);
    }
  }

  /// Reset scan settings
  Future<void> resetScanSettings() async {
    if (_repository == null) {
      AppLogger.w('Cannot reset scan settings: repository not initialized');
      return;
    }

    state = const AsyncValue.loading();
    try {
      final result = await _repository!.resetScanSettings();
      result.fold(
        onSuccess: (settings) {
          state = AsyncValue.data(settings);
          AppLogger.d('Scan settings reset successfully');
        },
        onFailure: (failure) {
          state = AsyncValue.error(failure, StackTrace.current);
          AppLogger.e('Failed to reset scan settings: ${failure.message}');
        },
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.e('Exception resetting scan settings: $e', stack);
    }
  }
}
