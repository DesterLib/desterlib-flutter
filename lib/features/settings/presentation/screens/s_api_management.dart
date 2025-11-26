// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/connection/presentation/widgets/m_api_configuration.dart';
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';

class ApiManagementScreen extends ConsumerWidget {
  const ApiManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configurations = ref
        .watch(connectionGuardProvider.notifier)
        .getApiConfigurations();
    final connectionState = ref.watch(connectionGuardProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DAppBar(
            title: AppLocalization.settingsServersApisTab.tr(),
            isCompact: true,
          ),
          configurations.isEmpty
              ? SliverFillRemaining(
                  child: DSidebarSpace(child: _buildEmptyState(context, ref)),
                )
              : _buildApiList(
                  context,
                  ref,
                  configurations,
                  connectionState.apiUrl,
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddApiModal(context, ref),
        icon: const Icon(LucideIcons.plus300),
        label: Text(AppLocalization.settingsServersAddApi.tr()),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: AppConstants.padding(AppConstants.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.cloudOff300, size: 64, color: Colors.grey[400]),
            AppConstants.spacingY(AppConstants.spacing16),
            Text(
              AppLocalization.settingsServersNoApisConfigured.tr(),
              style: AppTypography.titleLarge(color: Colors.grey[600]),
            ),
            AppConstants.spacingY(AppConstants.spacing8),
            Text(
              AppLocalization.settingsServersAddFirstApi.tr(),
              style: AppTypography.bodyMedium(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            AppConstants.spacingY(AppConstants.spacing24),
            ElevatedButton.icon(
              onPressed: () => _showAddApiModal(context, ref),
              icon: const Icon(LucideIcons.plus300),
              label: Text(AppLocalization.settingsServersAddApi.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiList(
    BuildContext context,
    WidgetRef ref,
    List<ApiConfiguration> configurations,
    String? activeApiUrl,
  ) {
    return SliverPadding(
      padding: AppConstants.padding(AppConstants.spacing16),
      sliver: SliverToBoxAdapter(
        child: DSidebarSpace(
          child: Column(
            children: configurations.map((config) {
              final isActive = config.isActive;
              final canDelete = configurations.length > 1;

              return Card(
                margin: AppConstants.paddingOnly(
                  bottom: AppConstants.spacing12,
                ),
                elevation: isActive ? 4 : 1,
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  side: BorderSide(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: isActive ? 2 : 0,
                  ),
                ),
                color: isActive
                    ? Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
                    child: Icon(
                      isActive
                          ? LucideIcons.cloudCheck300
                          : LucideIcons.cloud300,
                      color: isActive ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          config.label,
                          style:
                              AppTypography.titleMedium(
                                color: isActive
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ).copyWith(
                                fontWeight: isActive
                                    ? AppTypography.weightBold
                                    : AppTypography.weightRegular,
                              ),
                        ),
                      ),
                      if (isActive)
                        Padding(
                          padding: AppConstants.paddingOnly(
                            left: AppConstants.spacing8,
                          ),
                          child: Chip(
                            label: Text(
                              AppLocalization.settingsServersActive.tr(),
                              style: AppTypography.labelSmall(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppConstants.spacingY(AppConstants.spacing4),
                      Text(
                        config.url,
                        style: AppTypography.bodySmall(
                          color: isActive
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isActive)
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle_outline,
                          ), // Using Material icon as Lucide circleCheck not available
                          tooltip: AppLocalization.settingsServersSetActive
                              .tr(),
                          onPressed: () => _handleSetActive(ref, config.id),
                        ),
                      IconButton(
                        icon: const Icon(LucideIcons.pencil300),
                        tooltip: 'Edit',
                        onPressed: () =>
                            _showEditApiModal(context, ref, config),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2300),
                        tooltip: AppLocalization.settingsServersDelete.tr(),
                        color: Colors.red,
                        onPressed: canDelete
                            ? () => _handleDelete(context, ref, config)
                            : null,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showAddApiModal(BuildContext context, WidgetRef? ref) {
    ApiConfigurationModal.show(
      context,
      onSave: (url, label) {
        if (ref != null) {
          ref
              .read(connectionGuardProvider.notifier)
              .addApiConfiguration(url, label, setAsActive: true);
        }
      },
    );
  }

  void _showEditApiModal(
    BuildContext context,
    WidgetRef ref,
    ApiConfiguration config,
  ) {
    ApiConfigurationModal.show(
      context,
      initialConfig: config,
      onSave: (url, label) {
        // For now, we'll delete and recreate. In the future, we can add an update use case
        ref
            .read(connectionGuardProvider.notifier)
            .deleteApiConfiguration(config.id);
        ref
            .read(connectionGuardProvider.notifier)
            .addApiConfiguration(url, label, setAsActive: config.isActive);
      },
    );
  }

  void _handleSetActive(WidgetRef ref, String configurationId) {
    ref
        .read(connectionGuardProvider.notifier)
        .setActiveApiConfiguration(configurationId);
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    ApiConfiguration config,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.settingsServersDelete.tr()),
        content: Text('Are you sure you want to delete "${config.label}"?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            child: Text(AppLocalization.settingsServersClose.tr()),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalization.settingsServersDelete.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref
          .read(connectionGuardProvider.notifier)
          .deleteApiConfiguration(config.id);
    }
  }
}
