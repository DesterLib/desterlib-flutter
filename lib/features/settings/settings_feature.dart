// External packages
import 'package:shared_preferences/shared_preferences.dart';

// Dependency injection setup for Settings feature
import 'data/datasources/library_datasource.dart';
import 'data/datasources/settings_datasource.dart';
import 'data/datasources/settings_local_datasource.dart';
import 'data/repository/library_repository_impl.dart';
import 'data/repository/settings_repository_impl.dart';
import 'data/repository/settings_repository_local_first_impl.dart';
import 'domain/repository/settings_repository.dart';
import 'domain/services/settings_background_sync_service.dart';
import 'domain/services/settings_sync_service.dart';
import 'domain/usecases/delete_library.dart';
import 'domain/usecases/delete_library_impl.dart';
import 'domain/usecases/get_libraries.dart';
import 'domain/usecases/get_libraries_impl.dart';
import 'domain/usecases/get_settings.dart';
import 'domain/usecases/get_settings_impl.dart';
import 'domain/usecases/scan_library.dart';
import 'domain/usecases/scan_library_impl.dart';
import 'domain/usecases/update_library.dart';
import 'domain/usecases/update_library_impl.dart';
import 'domain/usecases/reset_settings.dart';
import 'domain/usecases/reset_settings_impl.dart';
import 'domain/usecases/update_settings.dart';
import 'domain/usecases/update_settings_impl.dart';
import 'presentation/screens/s_api_management.dart';
import 'presentation/screens/s_connection_setup.dart';
import 'presentation/screens/s_manage_libraries.dart';
import 'presentation/screens/s_metadata_providers.dart';
import 'presentation/screens/s_scan_settings.dart';
import 'presentation/screens/s_movie_scan_settings.dart';
import 'presentation/screens/s_tv_scan_settings.dart';
import 'presentation/screens/s_settings.dart';

class SettingsFeature {
  static SettingsScreen createSettingsScreen() {
    return const SettingsScreen();
  }

  static ApiManagementScreen createApiManagementScreen() {
    return const ApiManagementScreen();
  }

  static ConnectionSetupScreen createConnectionSetupScreen() {
    return const ConnectionSetupScreen();
  }

  static ManageLibrariesScreen createManageLibrariesScreen() {
    return const ManageLibrariesScreen();
  }

  static MetadataProvidersScreen createMetadataProvidersScreen() {
    return const MetadataProvidersScreen();
  }

  static ScanSettingsScreen createScanSettingsScreen() {
    return const ScanSettingsScreen();
  }

  static MovieScanSettingsScreen createMovieScanSettingsScreen() {
    return const MovieScanSettingsScreen();
  }

  static TvScanSettingsScreen createTvScanSettingsScreen() {
    return const TvScanSettingsScreen();
  }

  // Library use case factories
  static GetLibraries createGetLibraries() {
    final dataSource = LibraryDataSource();
    final repository = LibraryRepositoryImpl(dataSource: dataSource);
    return GetLibrariesImpl(repository);
  }

  static UpdateLibrary createUpdateLibrary() {
    final dataSource = LibraryDataSource();
    final repository = LibraryRepositoryImpl(dataSource: dataSource);
    return UpdateLibraryImpl(repository);
  }

  static DeleteLibrary createDeleteLibrary() {
    final dataSource = LibraryDataSource();
    final repository = LibraryRepositoryImpl(dataSource: dataSource);
    return DeleteLibraryImpl(repository);
  }

  static ScanLibrary createScanLibrary() {
    final dataSource = LibraryDataSource();
    final repository = LibraryRepositoryImpl(dataSource: dataSource);
    return ScanLibraryImpl(repository);
  }

  // Settings data source factories
  static SettingsDataSource createSettingsDataSource() {
    return SettingsDataSource();
  }

  static Future<SettingsLocalDataSource> createSettingsLocalDataSource() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsLocalDataSourceImpl(prefs);
  }

  // Settings sync service factories
  static Future<SettingsSyncService> createSettingsSyncService({
    required SettingsRepository repository,
    required SettingsLocalDataSource localDataSource,
  }) async {
    return SettingsSyncServiceImpl(
      repository: repository,
      localDataSource: localDataSource,
    );
  }

  static Future<SettingsBackgroundSyncService>
  createSettingsBackgroundSyncService({
    required SettingsSyncService syncService,
    required SettingsLocalDataSource localDataSource,
  }) async {
    return SettingsBackgroundSyncServiceImpl(
      syncService: syncService,
      localDataSource: localDataSource,
    );
  }

  // Settings repository factories (local-first)
  static Future<SettingsRepository> createSettingsRepositoryLocalFirst() async {
    final remoteDataSource = createSettingsDataSource();
    final localDataSource = await createSettingsLocalDataSource();

    // Create sync services
    final syncService = await createSettingsSyncService(
      repository: SettingsRepositoryImpl(dataSource: remoteDataSource),
      localDataSource: localDataSource,
    );

    final backgroundSyncService = await createSettingsBackgroundSyncService(
      syncService: syncService,
      localDataSource: localDataSource,
    );

    return SettingsRepositoryLocalFirstImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      backgroundSyncService: backgroundSyncService,
    );
  }

  // Settings use case factories (local-first)
  static Future<GetSettings> createGetSettings() async {
    final repository = await createSettingsRepositoryLocalFirst();
    return GetSettingsImpl(repository);
  }

  static Future<UpdateSettings> createUpdateSettings() async {
    final repository = await createSettingsRepositoryLocalFirst();
    return UpdateSettingsImpl(repository);
  }

  static Future<ResetAllSettings> createResetAllSettings() async {
    final repository = await createSettingsRepositoryLocalFirst();
    return ResetAllSettingsImpl(repository);
  }

  static Future<ResetScanSettings> createResetScanSettings() async {
    final repository = await createSettingsRepositoryLocalFirst();
    return ResetScanSettingsImpl(repository);
  }

  // Legacy factories (for backward compatibility during migration)
  static GetSettings createGetSettingsLegacy() {
    final dataSource = SettingsDataSource();
    final repository = SettingsRepositoryImpl(dataSource: dataSource);
    return GetSettingsImpl(repository);
  }

  static UpdateSettings createUpdateSettingsLegacy() {
    final dataSource = SettingsDataSource();
    final repository = SettingsRepositoryImpl(dataSource: dataSource);
    return UpdateSettingsImpl(repository);
  }

  static ResetAllSettings createResetAllSettingsLegacy() {
    final dataSource = SettingsDataSource();
    final repository = SettingsRepositoryImpl(dataSource: dataSource);
    return ResetAllSettingsImpl(repository);
  }

  static ResetScanSettings createResetScanSettingsLegacy() {
    final dataSource = SettingsDataSource();
    final repository = SettingsRepositoryImpl(dataSource: dataSource);
    return ResetScanSettingsImpl(repository);
  }
}
