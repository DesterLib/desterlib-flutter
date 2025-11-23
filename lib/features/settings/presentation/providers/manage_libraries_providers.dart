// External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Features
import 'package:dester/features/settings/domain/usecases/delete_library.dart';
import 'package:dester/features/settings/domain/usecases/get_libraries.dart';
import 'package:dester/features/settings/domain/usecases/scan_library.dart';
import 'package:dester/features/settings/domain/usecases/update_library.dart';
import 'package:dester/features/settings/presentation/controllers/manage_libraries_controller.dart';
import 'package:dester/features/settings/settings_feature.dart';


/// Provider for GetLibraries use case
final getLibrariesProvider = Provider<GetLibraries>((ref) {
  return SettingsFeature.createGetLibraries();
});

/// Provider for UpdateLibrary use case
final updateLibraryProvider = Provider<UpdateLibrary>((ref) {
  return SettingsFeature.createUpdateLibrary();
});

/// Provider for DeleteLibrary use case
final deleteLibraryProvider = Provider<DeleteLibrary>((ref) {
  return SettingsFeature.createDeleteLibrary();
});

/// Provider for ScanLibrary use case
final scanLibraryProvider = Provider<ScanLibrary>((ref) {
  return SettingsFeature.createScanLibrary();
});

/// Provider for ManageLibrariesController
final manageLibrariesControllerProvider =
    NotifierProvider<ManageLibrariesController, ManageLibrariesState>(() {
      return ManageLibrariesController();
    });
