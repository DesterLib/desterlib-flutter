import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/features/library/data/models/library_model.dart';
import 'package:dester/features/library/data/services/library_api_service.dart';

/// Provider for libraries list
final librariesProvider = FutureProvider<List<LibraryModel>>((ref) async {
  final service = ref.watch(libraryApiServiceProvider);
  return await service.getLibraries();
});

/// Provider for libraries with filtering
final librariesFilteredProvider =
    FutureProvider.family<List<LibraryModel>, LibraryFilters?>((
      ref,
      filters,
    ) async {
      final service = ref.watch(libraryApiServiceProvider);
      return await service.getLibraries(filters: filters);
    });

/// Provider for actual libraries only (isLibrary = true)
final actualLibrariesProvider = FutureProvider<List<LibraryModel>>((ref) async {
  final service = ref.watch(libraryApiServiceProvider);
  return await service.getLibraries(
    filters: const LibraryFilters(isLibrary: true),
  );
});

/// Provider for collections only (isLibrary = false)
final collectionsProvider = FutureProvider<List<LibraryModel>>((ref) async {
  final service = ref.watch(libraryApiServiceProvider);
  return await service.getLibraries(
    filters: const LibraryFilters(isLibrary: false),
  );
});

/// Provider for libraries by type
final librariesByTypeProvider =
    FutureProvider.family<List<LibraryModel>, LibraryType>((ref, type) async {
      final service = ref.watch(libraryApiServiceProvider);
      return await service.getLibraries(
        filters: LibraryFilters(libraryType: type),
      );
    });

/// State for library management operations
class LibraryManagementState {
  final bool isLoading;
  final String? error;
  final LibraryModel? selectedLibrary;

  const LibraryManagementState({
    this.isLoading = false,
    this.error,
    this.selectedLibrary,
  });

  LibraryManagementState copyWith({
    bool? isLoading,
    String? error,
    LibraryModel? selectedLibrary,
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
  Future<void> updateLibrary(LibraryUpdateRequest request) async {
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
      await service.deleteLibrary(LibraryDeleteRequest(id: libraryId));

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
  void selectLibrary(LibraryModel library) {
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
