// Dependency injection setup for Settings feature
import 'data/datasources/library_datasource.dart';
import 'data/datasources/settings_datasource.dart';
import 'data/repository/library_repository_impl.dart';
import 'data/repository/settings_repository_impl.dart';
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
import 'domain/usecases/update_settings.dart';
import 'domain/usecases/update_settings_impl.dart';
import 'presentation/screens/s_api_management.dart';
import 'presentation/screens/s_manage_libraries.dart';
import 'presentation/screens/s_settings.dart';


class SettingsFeature {
  static SettingsScreen createSettingsScreen() {
    return const SettingsScreen();
  }

  static ApiManagementScreen createApiManagementScreen() {
    return const ApiManagementScreen();
  }

  static ManageLibrariesScreen createManageLibrariesScreen() {
    return const ManageLibrariesScreen();
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

  // Settings use case factories
  static GetSettings createGetSettings() {
    final dataSource = SettingsDataSource();
    final repository = SettingsRepositoryImpl(dataSource: dataSource);
    return GetSettingsImpl(repository);
  }

  static UpdateSettings createUpdateSettings() {
    final dataSource = SettingsDataSource();
    final repository = SettingsRepositoryImpl(dataSource: dataSource);
    return UpdateSettingsImpl(repository);
  }
}
