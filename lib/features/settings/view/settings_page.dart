import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_events.dart';
import '../bloc/settings_states.dart';
import '../repo/settings_repository.dart';
import '../widgets/library_dialog.dart';

class SettingsPage extends StatelessWidget {
  final SettingsRepository settingsRepository;

  const SettingsPage({super.key, required this.settingsRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SettingsBloc(repository: settingsRepository)
            ..add(SettingsLoadRequested()),
      child: Builder(
        builder: (context) => SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Column(
                children: [
                  const SizedBox(height: 80), // Space for floating nav
                  // Header
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      final hasApiKey =
                          (state is SettingsLoaded ||
                              state is SettingsOperationInProgress ||
                              state is SettingsOperationSuccess)
                          ? _getAppSettings(state)?.tmdbApiKey?.isNotEmpty ??
                                false
                          : false;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Library Management',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Tooltip(
                              message: hasApiKey
                                  ? 'Add a new library'
                                  : 'Configure TMDB API key first',
                              child: ElevatedButton.icon(
                                onPressed: hasApiKey
                                    ? () => _showLibraryDialog(context, null)
                                    : () => _showApiKeyRequiredDialog(context),
                                icon: const Icon(Icons.add, size: 20),
                                label: const Text('Add Library'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: hasApiKey
                                      ? Colors.blue
                                      : Colors.grey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Content
                  Expanded(
                    child: BlocConsumer<SettingsBloc, SettingsState>(
                      listener: (context, state) {
                        if (state is SettingsOperationSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is SettingsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        } else if (state is SettingsError) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error',
                                  style: TextStyle(
                                    color: Colors.red.shade300,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<SettingsBloc>()
                                      .add(SettingsLoadRequested()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (state is SettingsLoaded ||
                            state is SettingsOperationInProgress ||
                            state is SettingsOperationSuccess) {
                          List<Library> libraries;
                          AppSettings appSettings;
                          String? operationMessage;

                          if (state is SettingsLoaded) {
                            libraries = state.libraries;
                            appSettings = state.appSettings;
                          } else if (state is SettingsOperationInProgress) {
                            libraries = state.libraries;
                            appSettings = state.appSettings;
                            operationMessage = state.operation;
                          } else {
                            final successState =
                                state as SettingsOperationSuccess;
                            libraries = successState.libraries;
                            appSettings = successState.appSettings;
                          }

                          final isOperating =
                              state is SettingsOperationInProgress;

                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<SettingsBloc>().add(
                                SettingsRefreshRequested(),
                              );
                            },
                            color: Colors.blue,
                            backgroundColor: Colors.grey.shade800,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                if (isOperating)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          operationMessage ?? 'Processing...',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (isOperating) const SizedBox(height: 16),
                                // TMDB API Key Section
                                _buildTmdbSection(context, appSettings),
                                const SizedBox(height: 24),
                                // Libraries Section
                                libraries.isEmpty
                                    ? _buildEmptyState(context)
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Libraries',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          ..._buildLibraryCards(
                                            context,
                                            libraries,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppSettings? _getAppSettings(SettingsState state) {
    if (state is SettingsLoaded) {
      return state.appSettings;
    } else if (state is SettingsOperationInProgress) {
      return state.appSettings;
    } else if (state is SettingsOperationSuccess) {
      return state.appSettings;
    }
    return null;
  }

  void _showApiKeyRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade300),
            const SizedBox(width: 12),
            const Text(
              'TMDB API Key Required',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          'You need to configure your TMDB API key before adding libraries. '
          'The API key is required to fetch metadata for your movies and TV shows.\n\n'
          'Please scroll up and enter your TMDB API key in the configuration section.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final hasApiKey =
            _getAppSettings(state)?.tmdbApiKey?.isNotEmpty ?? false;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Libraries Yet',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasApiKey
                      ? 'Add your first library to get started'
                      : 'Configure your TMDB API key above, then add a library',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: hasApiKey
                      ? () => _showLibraryDialog(context, null)
                      : () => _showApiKeyRequiredDialog(context),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Library'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasApiKey ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildLibraryCards(
    BuildContext context,
    List<Library> libraries,
  ) {
    return libraries.map((library) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        child: _LibraryCard(
          library: library,
          onEdit: () => _showLibraryDialog(context, library),
          onDelete: () => _showDeleteConfirmation(context, library),
          onScan: () {
            context.read<SettingsBloc>().add(
              LibraryScanRequested(libraryId: library.id),
            );
          },
        ),
      );
    }).toList();
  }

  Widget _buildTmdbSection(BuildContext context, AppSettings settings) {
    final tmdbController = TextEditingController(
      text: settings.tmdbApiKey ?? '',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TMDB API Key',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configure your The Movie Database API key for fetching metadata',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tmdbController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'API Key',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    hintText: 'Enter your TMDB API key',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(
                        AppSettingsUpdateRequested(
                          tmdbApiKey: tmdbController.text,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save API Key'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLibraryDialog(
    BuildContext context,
    Library? library,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => LibraryDialog(library: library),
    );

    if (result != null && context.mounted) {
      if (library == null) {
        // Create new library
        context.read<SettingsBloc>().add(
          LibraryCreateRequested(
            name: result['name'],
            path: result['path'],
            type: result['type'],
          ),
        );
      } else {
        // Update existing library
        context.read<SettingsBloc>().add(
          LibraryUpdateRequested(
            id: result['id'],
            name: result['name'],
            path: result['path'],
            type: result['type'],
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    Library library,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: const Text(
          'Delete Library',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${library.name}"? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<SettingsBloc>().add(LibraryDeleteRequested(id: library.id));
    }
  }
}

class _LibraryCard extends StatelessWidget {
  final Library library;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onScan;

  const _LibraryCard({
    required this.library,
    required this.onEdit,
    required this.onDelete,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  library.type == 'MOVIE'
                      ? Icons.movie_outlined
                      : Icons.tv_outlined,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      library.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      library.type == 'MOVIE' ? 'Movies' : 'TV Shows',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    onPressed: onScan,
                    tooltip: 'Scan Library',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white70,
                    ),
                    onPressed: onEdit,
                    tooltip: 'Edit Library',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade300,
                    ),
                    onPressed: onDelete,
                    tooltip: 'Delete Library',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 16,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    library.path,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (library.mediaCount != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 16,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  '${library.mediaCount} items',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
