// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/websocket/websocket_provider.dart';
import 'package:dester/core/widgets/empty_state_widget.dart';
import 'package:dester/core/widgets/error_state_widget.dart';
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';
import 'package:dester/features/settings/presentation/controllers/manage_libraries_controller.dart';
import 'package:dester/features/settings/presentation/providers/manage_libraries_providers.dart';
import 'package:dester/features/settings/presentation/screens/s_settings.dart';
import 'package:dester/features/settings/presentation/widgets/add_library_fab.dart';
import 'package:dester/features/settings/presentation/widgets/library_card.dart';
import 'package:dester/features/settings/presentation/widgets/m_delete_library.dart';
import 'package:dester/features/settings/presentation/widgets/m_library.dart';

class ManageLibrariesScreen extends ConsumerWidget {
  const ManageLibrariesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(manageLibrariesControllerProvider.notifier);
    final state = ref.watch(manageLibrariesControllerProvider);
    final libraries = state.libraries;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.refresh(),
        child: CustomScrollView(
          slivers: [
            DAppBar(
              title: AppLocalization.settingsLibrariesManageLibraries.tr(),
              isCompact: true,
              actions: [
                IconButton(
                  icon: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(LucideIcons.refreshCw300),
                  tooltip: 'Refresh',
                  onPressed: state.isLoading
                      ? null
                      : () => controller.refresh(),
                ),
              ],
            ),
            state.isLoading && libraries.isEmpty
                ? SliverFillRemaining(
                    child: DSidebarSpace(
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  )
                : state.error != null && libraries.isEmpty
                ? SliverFillRemaining(
                    child: DSidebarSpace(
                      child: ErrorStateWidget(
                        error: state.error!,
                        onRetry: () => controller.refresh(),
                      ),
                    ),
                  )
                : libraries.isEmpty
                ? SliverFillRemaining(
                    child: DSidebarSpace(
                      child: EmptyStateWidget(
                        title: AppLocalization
                            .settingsLibrariesNoLibrariesAvailable
                            .tr(),
                        subtitle: AppLocalization
                            .settingsLibrariesAddFirstLibrary
                            .tr(),
                        icon: LucideIcons.library300,
                      ),
                    ),
                  )
                : _buildLibraryList(context, ref, libraries, controller, state),
          ],
        ),
      ),
      floatingActionButton: AddLibraryFAB(
        onPressed: () => _showAddLibraryModal(context, ref),
      ),
    );
  }

  Widget _buildLibraryList(
    BuildContext context,
    WidgetRef ref,
    List<Library> libraries,
    ManageLibrariesController controller,
    ManageLibrariesState state,
  ) {
    return SliverPadding(
      padding: AppConstants.padding(AppConstants.spacing16),
      sliver: SliverList.builder(
        itemCount: libraries.length,
        itemBuilder: (context, index) {
          final library = libraries[index];

          // Watch scanProgressProvider directly for real-time updates
          final scanProgressState = ref.watch(scanProgressProvider);
          final scanProgress =
              scanProgressState.libraryId != null &&
                  scanProgressState.libraryId!.isNotEmpty &&
                  scanProgressState.libraryId == library.id &&
                  scanProgressState.isScanning
              ? scanProgressState
              : null;
          final isScanning = scanProgress != null;

          return DSidebarSpace(
            child: LibraryCard(
              library: library,
              isScanning: isScanning,
              scanProgress: scanProgress,
              onEdit: () =>
                  _showEditLibraryModal(context, ref, library, controller),
              onDelete: () => _handleDelete(context, ref, library, controller),
            ),
          );
        },
      ),
    );
  }

  void _showAddLibraryModal(BuildContext context, WidgetRef ref) async {
    // Check if TMDB API key exists before showing modal
    final currentSettings = await ref.read(settingsProvider.future);

    if (!context.mounted) return;

    final hasTmdbApiKey =
        currentSettings.tmdbApiKey != null &&
        currentSettings.tmdbApiKey!.isNotEmpty;

    if (!hasTmdbApiKey) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalization.settingsTmdbApiKeyRequiredForLibrary.tr(),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    LibraryModal.show(
      context,
      isEditMode: false,
      onSave: (name, description, libraryPath, libraryType) async {
        // Double-check TMDB API key before creating library
        final settings = await ref.read(settingsProvider.future);
        final hasKey =
            settings.tmdbApiKey != null && settings.tmdbApiKey!.isNotEmpty;

        if (!hasKey) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalization.settingsTmdbApiKeyRequiredForLibrary.tr(),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          return;
        }

        if (libraryPath == null || libraryPath.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppLocalization.settingsLibrariesLibraryPath.tr()} is required',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        if (!context.mounted) return;

        final controller = ref.read(manageLibrariesControllerProvider.notifier);
        final mediaType = libraryType != null
            ? (libraryType == LibraryType.movie
                  ? 'movie'
                  : libraryType == LibraryType.tvShow
                  ? 'tv'
                  : null)
            : null;

        try {
          await controller.startScan(
            libraryPath: libraryPath,
            libraryName: name,
            description: description,
            libraryType: libraryType,
            mediaType: mediaType,
            context: context,
          );
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error starting scan: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  void _showEditLibraryModal(
    BuildContext context,
    WidgetRef ref,
    Library library,
    ManageLibrariesController controller,
  ) {
    LibraryModal.show(
      context,
      library: library,
      isEditMode: true,
      onSave: (name, description, libraryPath, libraryType) async {
        try {
          await controller.updateLibrary(
            id: library.id,
            name: name,
            description: description,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppLocalization.settingsLibrariesEditLibrary.tr()} ${AppLocalization.settingsServersSave.tr().toLowerCase()}',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    Library library,
    ManageLibrariesController controller,
  ) async {
    final confirmed = await DeleteLibraryDialog.show(context, library: library);

    if (confirmed == true && context.mounted) {
      try {
        await controller.deleteLibrary(library.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${library.name} ${AppLocalization.settingsServersDelete.tr().toLowerCase()}',
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
