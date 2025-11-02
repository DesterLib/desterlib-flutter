import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/features/library/data/services/library_api_service.dart';

/// Provider for libraries list
final librariesProvider = FutureProvider<BuiltList<ModelLibrary>>((ref) async {
  final service = ref.watch(libraryApiServiceProvider);
  return await service.getLibraries();
});

/// Provider for libraries with optional filtering
final librariesFilteredProvider =
    FutureProvider.family<
      BuiltList<ModelLibrary>,
      ({bool? isLibrary, ModelLibraryLibraryTypeEnum? libraryType})
    >((ref, filters) async {
      final service = ref.watch(libraryApiServiceProvider);
      return await service.getLibraries(
        isLibrary: filters.isLibrary,
        libraryType: filters.libraryType,
      );
    });

/// Provider for actual libraries only (isLibrary = true)
final actualLibrariesProvider = FutureProvider<BuiltList<ModelLibrary>>((
  ref,
) async {
  final service = ref.watch(libraryApiServiceProvider);
  return await service.getLibraries(isLibrary: true);
});

/// Provider for collections only (isLibrary = false)
final collectionsProvider = FutureProvider<BuiltList<ModelLibrary>>((
  ref,
) async {
  final service = ref.watch(libraryApiServiceProvider);
  return await service.getLibraries(isLibrary: false);
});

/// Provider for libraries by type
final librariesByTypeProvider =
    FutureProvider.family<BuiltList<ModelLibrary>, ModelLibraryLibraryTypeEnum>(
      (ref, type) async {
        final service = ref.watch(libraryApiServiceProvider);
        return await service.getLibraries(libraryType: type);
      },
    );

/// State for library management operations
class LibraryManagementState {
  final bool isLoading;
  final String? error;
  final ModelLibrary? selectedLibrary;

  const LibraryManagementState({
    this.isLoading = false,
    this.error,
    this.selectedLibrary,
  });

  LibraryManagementState copyWith({
    bool? isLoading,
    String? error,
    ModelLibrary? selectedLibrary,
  }) {
    return LibraryManagementState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedLibrary: selectedLibrary ?? this.selectedLibrary,
    );
  }
}

/// Provider for library management state
final libraryManagementProvider =
    NotifierProvider<LibraryManagementNotifier, LibraryManagementState>(() {
      return LibraryManagementNotifier();
    });

/// Notifier for library management operations
class LibraryManagementNotifier extends Notifier<LibraryManagementState> {
  @override
  LibraryManagementState build() {
    return const LibraryManagementState();
  }

  /// Update library details
  Future<void> updateLibrary(ApiV1LibraryPutRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(libraryApiServiceProvider);
      await service.updateLibrary(request);

      // Refresh libraries list
      ref.invalidate(librariesProvider);
      ref.invalidate(actualLibrariesProvider);
      ref.invalidate(collectionsProvider);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Delete library
  Future<void> deleteLibrary(String libraryId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(libraryApiServiceProvider);
      final deleteRequest = ApiV1LibraryDeleteRequestBuilder()..id = libraryId;
      await service.deleteLibrary(deleteRequest.build());

      // Refresh libraries list
      ref.invalidate(librariesProvider);
      ref.invalidate(actualLibrariesProvider);
      ref.invalidate(collectionsProvider);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Set selected library for editing
  void selectLibrary(ModelLibrary library) {
    state = state.copyWith(selectedLibrary: library);
  }

  /// Clear selected library
  void clearSelectedLibrary() {
    state = state.copyWith(selectedLibrary: null);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for refresh functionality
final refreshLibrariesProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(librariesProvider);
    ref.invalidate(actualLibrariesProvider);
    ref.invalidate(collectionsProvider);
  };
});
