// Dart
import 'dart:async';

// External packages
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/websocket/websocket_provider.dart';
import 'package:dester/core/websocket/websocket_service.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';
import 'package:dester/features/settings/presentation/providers/manage_libraries_providers.dart';

/// State for manage libraries screen
class ManageLibrariesState {
  final List<Library> libraries;
  final bool isLoading;
  final String? error;

  const ManageLibrariesState({
    this.libraries = const [],
    this.isLoading = false,
    this.error,
  });

  ManageLibrariesState copyWith({
    List<Library>? libraries,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ManageLibrariesState(
      libraries: libraries ?? this.libraries,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for managing libraries
class ManageLibrariesController extends Notifier<ManageLibrariesState> {
  Timer? _debounceTimer;

  @override
  ManageLibrariesState build() {
    // Load libraries after initialization completes
    Future.microtask(() => _loadLibraries());

    // Set up persistent listener for scan progress to refresh libraries
    // This ensures media count updates live during scanning
    ref.listen<ScanProgressState>(scanProgressProvider, (previous, next) {
      if (next.libraryId == null || next.libraryId!.isEmpty) {
        // No active scan, cancel any pending refresh
        _cancelDebounceTimer();
        return;
      }

      // Check if this library is in our list
      final currentState = ref.read(manageLibrariesControllerProvider);
      final libraryExists = currentState.libraries.any(
        (lib) => lib.id == next.libraryId,
      );

      if (!libraryExists) {
        _cancelDebounceTimer();
        return;
      }

      // Refresh when we receive updates during phases where items are being saved
      // - "saving" phase: items are being saved to database
      // - "batch-complete" phase: a batch of items was saved
      // The debounce will handle batching rapid updates
      if (next.isScanning &&
          (next.phase == ScanProgressPhase.saving ||
              next.phase == ScanProgressPhase.batchComplete)) {
        _scheduleDebouncedRefresh();
      }

      // When scan completes, refresh to get final updated media count
      if (previous != null && previous.isScanning && !next.isScanning) {
        _cancelDebounceTimer();
        // Small delay to ensure backend has updated the media count
        // Use background refresh to avoid showing loading indicator
        Future.delayed(AppConstants.durationSlow, () {
          _refreshBackground();
        });
      }
    });

    // Clean up timer when controller is disposed
    ref.onDispose(() {
      _cancelDebounceTimer();
    });

    return const ManageLibrariesState();
  }

  void _scheduleDebouncedRefresh() {
    // Cancel any existing debounce timer
    _cancelDebounceTimer();

    // Debounce: refresh after a short delay to batch rapid updates
    // This prevents excessive API calls while still updating frequently
    // Using a shorter delay (200ms) to ensure updates happen quickly
    // Use background refresh to avoid showing loading indicator
    _debounceTimer = Timer(AppConstants.fadeInDelay, () {
      _refreshBackground();
    });
  }

  void _cancelDebounceTimer() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Load libraries from repository
  Future<void> _loadLibraries({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(isLoading: true, error: null);
    }
    try {
      final getLibraries = ref.read(getLibrariesProvider);
      final libraries = await getLibraries();
      state = state.copyWith(libraries: libraries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh libraries (shows loading indicator)
  Future<void> refresh() async {
    await _loadLibraries(showLoading: true);
  }

  /// Background refresh libraries (doesn't show loading indicator)
  /// Used for automatic updates during scanning
  Future<void> _refreshBackground() async {
    await _loadLibraries(showLoading: false);
  }

  /// Start scanning a library
  /// The backend creates the library synchronously before scanning starts,
  /// so we refresh the libraries list immediately after starting the scan
  Future<void> startScan({
    required String libraryPath,
    required String libraryName,
    String? description,
    LibraryType? libraryType,
    String? mediaType,
    required BuildContext context,
  }) async {
    final scanLibrary = ref.read(scanLibraryProvider);
    try {
      // Start the scan - the backend creates the library synchronously before scanning
      await scanLibrary(
        path: libraryPath,
        libraryName: libraryName,
        mediaType: mediaType,
      );

      // Refresh libraries immediately to get the newly created library
      // The library is created synchronously in the backend before scan starts
      await refresh();
      // Note: Scan completion is handled by the persistent listener in build()
    } catch (e) {
      // Error is already handled by the caller
      rethrow;
    }
  }

  /// Soft rescan: Only checks for new/removed files, doesn't refetch metadata
  /// Uses the library's existing path and type settings
  Future<void> rescanLibrary({
    required Library library,
    required BuildContext context,
  }) async {
    if (library.libraryPath == null || library.libraryPath!.isEmpty) {
      throw Exception('Library path is not set for this library');
    }

    final scanLibrary = ref.read(scanLibraryProvider);
    try {
      // Convert LibraryType to mediaType string
      final mediaType = library.libraryType != null
          ? (library.libraryType == LibraryType.movie
                ? 'movie'
                : library.libraryType == LibraryType.tvShow
                ? 'tv'
                : null)
          : null;

      // Start soft rescan: rescan=true, refetchMetadata=false
      await scanLibrary(
        path: library.libraryPath!,
        libraryName: library.name,
        mediaType: mediaType,
        rescan: true,
        refetchMetadata: false,
      );

      // Refresh libraries to update scan status
      await refresh();
      // Note: Scan completion is handled by the persistent listener in build()
    } catch (e) {
      // Error is already handled by the caller
      rethrow;
    }
  }

  /// Hard rescan: Refetches ALL metadata with force
  /// Uses the library's existing path and type settings
  Future<void> hardRescanLibrary({
    required Library library,
    required BuildContext context,
  }) async {
    if (library.libraryPath == null || library.libraryPath!.isEmpty) {
      throw Exception('Library path is not set for this library');
    }

    final scanLibrary = ref.read(scanLibraryProvider);
    try {
      // Convert LibraryType to mediaType string
      final mediaType = library.libraryType != null
          ? (library.libraryType == LibraryType.movie
                ? 'movie'
                : library.libraryType == LibraryType.tvShow
                ? 'tv'
                : null)
          : null;

      // Start hard rescan: rescan=true, refetchMetadata=true
      await scanLibrary(
        path: library.libraryPath!,
        libraryName: library.name,
        mediaType: mediaType,
        rescan: true,
        refetchMetadata: true,
      );

      // Refresh libraries to update scan status
      await refresh();
      // Note: Scan completion is handled by the persistent listener in build()
    } catch (e) {
      // Error is already handled by the caller
      rethrow;
    }
  }

  /// Update a library
  Future<void> updateLibrary({
    required String id,
    required String name,
    String? description,
  }) async {
    try {
      final updateLibrary = ref.read(updateLibraryProvider);
      await updateLibrary(
        id: id,
        name: name,
        description: description,
        libraryPath: null,
        libraryType: null,
      );
      await refresh();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Delete a library
  Future<void> deleteLibrary(String id) async {
    try {
      final deleteLibrary = ref.read(deleteLibraryProvider);
      await deleteLibrary(id);
      await refresh();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Get scan progress for a specific library
  ScanProgressState? getScanProgressForLibrary(Library library) {
    final scanProgress = ref.read(scanProgressProvider);

    // Match progress by libraryId (exact match)
    if (scanProgress.libraryId != null &&
        scanProgress.libraryId!.isNotEmpty &&
        scanProgress.libraryId == library.id &&
        scanProgress.isScanning) {
      return scanProgress;
    }

    return null;
  }

  /// Check if a library is currently being scanned
  bool isLibraryScanning(Library library) {
    final webSocketConnection = ref.read(webSocketConnectionProvider);
    final isWebSocketConnected = webSocketConnection.when(
      data: (value) => value,
      loading: () => false,
      error: (_, _) => false,
    );

    if (!isWebSocketConnected) {
      return false;
    }

    return getScanProgressForLibrary(library) != null;
  }
}
