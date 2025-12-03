// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_loading_wrapper.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/websocket/websocket_provider.dart';
import 'package:dester/core/widgets/empty_state_widget.dart';
import 'package:dester/core/widgets/error_state_widget.dart';
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_bottom_nav_space.dart';
import 'package:dester/core/widgets/d_button.dart';
import 'package:dester/core/widgets/d_icon_button.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';
import 'package:dester/features/settings/presentation/controllers/manage_libraries_controller.dart';
import 'package:dester/features/settings/presentation/providers/manage_libraries_providers.dart';
import 'package:dester/features/settings/presentation/providers/settings_providers.dart';
import 'package:dester/features/settings/presentation/widgets/library_card.dart';
import 'package:dester/features/settings/presentation/widgets/m_delete_library.dart';
import 'package:dester/features/settings/presentation/widgets/m_library.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';

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
                Tooltip(
                  message: AppLocalization.settingsLibrariesAddLibrary.tr(),
                  child: DIconButton(
                    icon: DIconName.plus,
                    variant: DIconButtonVariant.plain,
                    onPressed: () => _showAddLibraryModal(context, ref),
                  ),
                ),
                Tooltip(
                  message: 'Refresh',
                  child: _SpinningRefreshButton(
                    isLoading: state.isLoading,
                    onPressed: () => controller.refresh(),
                  ),
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: DLoadingWrapper(
                isLoading: state.isLoading && libraries.isEmpty,
                loader: const DSidebarSpace(
                  child: DBottomNavSpace(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                child: state.error != null && libraries.isEmpty
                    ? DSidebarSpace(
                        child: DBottomNavSpace(
                          child: ErrorStateWidget(
                            error: state.error!,
                            onRetry: () => controller.refresh(),
                          ),
                        ),
                      )
                    : libraries.isEmpty
                    ? DSidebarSpace(
                        child: DBottomNavSpace(
                          child: EmptyStateWidget(
                            title: AppLocalization
                                .settingsLibrariesNoLibrariesAvailable
                                .tr(),
                            subtitle: AppLocalization
                                .settingsLibrariesAddFirstLibrary
                                .tr(),
                            icon: DIconName.library,
                            action: DButton(
                              onPressed: () =>
                                  _showAddLibraryModal(context, ref),
                              leadingIcon: DIconName.plus,
                              label: AppLocalization.settingsLibrariesAddLibrary
                                  .tr(),
                              variant: DButtonVariant.primary,
                            ),
                          ),
                        ),
                      )
                    : _buildLibraryListWidget(
                        context,
                        ref,
                        libraries,
                        controller,
                        state,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryListWidget(
    BuildContext context,
    WidgetRef ref,
    List<Library> libraries,
    ManageLibrariesController controller,
    ManageLibrariesState state,
  ) {
    return Padding(
      padding: AppConstants.padding(AppConstants.spacing16),
      child: DSidebarSpace(
        child: Column(
          children: [
            SettingsSection(
              title: AppLocalization.settingsLibrariesTitle.tr(),
              group: SettingsGroup(
                children: libraries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final library = entry.value;

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

                  return LibraryCard(
                    library: library,
                    isScanning: isScanning,
                    scanProgress: scanProgress,
                    onEdit: () => _showEditLibraryModal(
                      context,
                      ref,
                      library,
                      controller,
                    ),
                    onDelete: () =>
                        _handleDelete(context, ref, library, controller),
                    inGroup: true,
                    isFirst: index == 0,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: AppConstants.spacing16),
            const DBottomNavSpace(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void _showAddLibraryModal(BuildContext context, WidgetRef ref) async {
    // Check if metadata provider is configured before showing modal
    final settingsAsync = ref.read(settingsProvider);

    if (!context.mounted) return;

    // Check if settings are loaded and has metadata provider
    final hasMetadataProvider = settingsAsync.when(
      data: (settings) => settings.hasMetadataProvider,
      loading: () => false,
      error: (_, __) => false,
    );

    if (!hasMetadataProvider) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalization.settingsTmdbApiKeyRequiredForLibrary.tr(),
          ),
          backgroundColor: Colors.red,
          duration: AppConstants.duration4s,
        ),
      );
      return;
    }

    LibraryModal.show(
      context,
      isEditMode: false,
      onSave: (name, description, libraryPath, libraryType) async {
        // Double-check metadata provider is configured before creating library
        final settingsAsync = ref.read(settingsProvider);

        final hasMetadataProvider = settingsAsync.when(
          data: (settings) => settings.hasMetadataProvider,
          loading: () => false,
          error: (_, __) => false,
        );

        if (!hasMetadataProvider) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalization.settingsTmdbApiKeyRequiredForLibrary.tr(),
                ),
                backgroundColor: Colors.red,
                duration: AppConstants.duration4s,
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

class _SpinningRefreshButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SpinningRefreshButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<_SpinningRefreshButton> createState() => _SpinningRefreshButtonState();
}

class _SpinningRefreshButtonState extends State<_SpinningRefreshButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      upperBound: double.infinity,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onPressed();
    _controller.animateTo(_controller.value + 0.5, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: DIconButton(
        icon: DIconName.refreshCw,
        variant: DIconButtonVariant.plain,
        onPressed: widget.isLoading ? null : _onTap,
        isDisabled: widget.isLoading,
      ),
    );
  }
}
