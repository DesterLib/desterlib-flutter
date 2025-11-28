// External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:dester/core/utils/app_logger.dart';

// Features
import 'package:dester/features/settings/data/datasources/settings_datasource.dart';
import 'package:dester/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:dester/features/settings/data/repository/settings_repository_impl.dart';
import 'package:dester/features/settings/data/repository/settings_repository_local_first_impl.dart';
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/repository/settings_local_data_source_interface.dart';
import 'package:dester/features/settings/domain/repository/settings_repository.dart';
import 'package:dester/features/settings/domain/services/settings_background_sync_service.dart';
import 'package:dester/features/settings/domain/services/settings_sync_service.dart';
import 'package:dester/features/settings/presentation/providers/settings_state_notifier.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  try {
    return await SharedPreferences.getInstance();
  } catch (e) {
    AppLogger.e('Failed to initialize SharedPreferences: $e');
    rethrow;
  }
});

/// Provider for local data source
final settingsLocalDataSourceProvider =
    FutureProvider<SettingsLocalDataSourceInterface>((ref) async {
      try {
        final prefs = await ref.watch(sharedPreferencesProvider.future);
        return SettingsLocalDataSourceImpl(prefs);
      } catch (e) {
        AppLogger.e('Failed to create local data source: $e');
        rethrow;
      }
    });

/// Provider for remote data source
final settingsRemoteDataSourceProvider = Provider<SettingsDataSource>((ref) {
  return SettingsDataSource();
});

/// Provider for sync service
final settingsSyncServiceProvider = FutureProvider<SettingsSyncService>((
  ref,
) async {
  try {
    final localDataSource = await ref.watch(
      settingsLocalDataSourceProvider.future,
    );
    final remoteDataSource = ref.watch(settingsRemoteDataSourceProvider);

    // Create a temporary repository for sync service
    // This is used only for sync operations, not for regular settings access
    final tempRepository = SettingsRepositoryImpl(dataSource: remoteDataSource);

    return SettingsSyncServiceImpl(
      repository: tempRepository,
      localDataSource: localDataSource,
    );
  } catch (e) {
    AppLogger.e('Failed to create sync service: $e');
    rethrow;
  }
});

/// Provider for background sync service
final settingsBackgroundSyncServiceProvider =
    FutureProvider<SettingsBackgroundSyncService>((ref) async {
      try {
        final syncService = await ref.watch(settingsSyncServiceProvider.future);
        final localDataSource = await ref.watch(
          settingsLocalDataSourceProvider.future,
        );

        return SettingsBackgroundSyncServiceImpl(
          syncService: syncService,
          localDataSource: localDataSource,
        );
      } catch (e) {
        AppLogger.e('Failed to create background sync service: $e');
        rethrow;
      }
    });

/// Provider for local-first settings repository
final settingsRepositoryProvider = FutureProvider<SettingsRepository>((
  ref,
) async {
  try {
    final remoteDataSource = ref.watch(settingsRemoteDataSourceProvider);
    final localDataSource = await ref.watch(
      settingsLocalDataSourceProvider.future,
    );
    final backgroundSyncService = await ref.watch(
      settingsBackgroundSyncServiceProvider.future,
    );

    final repository = SettingsRepositoryLocalFirstImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      backgroundSyncService: backgroundSyncService,
    );

    AppLogger.d('Settings repository initialized');
    return repository;
  } catch (e) {
    AppLogger.e('Failed to create settings repository: $e');
    rethrow;
  }
});

/// Provider for settings notifier
/// Uses AsyncNotifierProvider for proper async initialization
final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);

/// Initialize settings notifier with repository when ready
final settingsNotifierInitializerProvider = FutureProvider<void>((ref) async {
  try {
    final repository = await ref.watch(settingsRepositoryProvider.future);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    notifier.setRepository(repository);
    AppLogger.d('Settings notifier initialized with repository');
  } catch (e) {
    AppLogger.e('Failed to initialize settings notifier: $e');
    rethrow;
  }
});

/// Provider for current settings (reactive)
/// Automatically initializes notifier when accessed
final settingsProvider = Provider<AsyncValue<Settings>>((ref) {
  // Ensure notifier is initialized
  ref.watch(settingsNotifierInitializerProvider);

  // Return current settings state
  return ref.watch(settingsNotifierProvider);
});
