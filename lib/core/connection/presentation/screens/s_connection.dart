// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/connection/domain/entities/connection_status.dart';
import 'package:dester/core/connection/presentation/widgets/m_api_configuration.dart';
import 'package:dester/core/connection/presentation/widgets/m_api_configuration.dart';
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_app_bar.dart';

/// Full-screen connection setup screen
/// Shown on initial load when no API is configured or connection fails
class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  bool _isInitialLoad = true;
  bool _showContent = false;
  ConnectionStatus? _previousStatus;
  DateTime? _loadStartTime;
  bool _connectionCheckCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadStartTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionGuardProvider);
    final status = connectionState.status;
    final configurations = ref
        .read(connectionGuardProvider.notifier)
        .getApiConfigurations();

    // Detect when connection check completes (status changes from checking to something else)
    if (_previousStatus == ConnectionStatus.checking &&
        status != ConnectionStatus.checking &&
        _isInitialLoad &&
        !_connectionCheckCompleted) {
      _connectionCheckCompleted = true;

      // Calculate remaining time to ensure minimum display time
      final elapsed = DateTime.now().difference(_loadStartTime!);
      final remainingTime = AppConstants.minimumSpinnerDisplay - elapsed;
      final delay = remainingTime.isNegative
          ? AppConstants.additionalDelay
          : remainingTime + AppConstants.additionalDelay;

      // Wait for minimum display time, then show content
      Future.delayed(delay, () {
        if (mounted) {
          setState(() {
            _isInitialLoad = false;
          });
          // Fade in content after a brief delay
          Future.delayed(AppConstants.fadeInDelay, () {
            if (mounted) {
              setState(() {
                _showContent = true;
              });
            }
          });
        }
      });
    }

    // Update previous status
    _previousStatus = status;

    // Show spinner during initial load or while checking connection
    final isLoading = _isInitialLoad || status == ConnectionStatus.checking;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DAppBar(
            title: AppLocalization.settingsServersTitle.tr(),
            automaticallyImplyLeading: false,
          ),
          isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverToBoxAdapter(
                  child: AnimatedOpacity(
                    opacity: _showContent ? 1.0 : 0.0,
                    duration: AppConstants.fadeTransition,
                    child: Padding(
                      padding: AppConstants.padding(AppConstants.spacingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // API Management Section
                          _buildApiManagementSection(context, configurations),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildApiManagementSection(
    BuildContext context,
    List<ApiConfiguration> configurations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.cloud,
                  color: Theme.of(context).colorScheme.primary,
                ),
                AppConstants.spacingX(AppConstants.spacingSm),
                Text(
                  AppLocalization.settingsServersApisTab.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddApiModal(context),
              icon: const Icon(LucideIcons.plus),
              label: Text(AppLocalization.settingsServersAddApi.tr()),
            ),
          ],
        ),
        AppConstants.spacingY(AppConstants.spacingMd),
        if (configurations.isEmpty)
          _buildEmptyState(context)
        else
          ...configurations.map(
            (config) => _buildApiConfigCard(context, config),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppConstants.padding(AppConstants.spacingXl),
        child: Column(
          children: [
            Icon(LucideIcons.cloudOff, size: 64, color: Colors.grey[400]),
            AppConstants.spacingY(AppConstants.spacingMd),
            Text(
              AppLocalization.settingsServersNoApisConfigured.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            AppConstants.spacingY(AppConstants.spacingSm),
            Text(
              AppLocalization.settingsServersAddFirstApi.tr(),
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            AppConstants.spacingY(AppConstants.spacingLg),
            ElevatedButton.icon(
              onPressed: () => _showAddApiModal(context),
              icon: const Icon(LucideIcons.plus),
              label: Text(AppLocalization.settingsServersAddApi.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiConfigCard(BuildContext context, ApiConfiguration config) {
    final isActive = config.isActive;
    final canDelete =
        ref
            .read(connectionGuardProvider.notifier)
            .getApiConfigurations()
            .length >
        1;

    return Card(
      margin: AppConstants.paddingOnly(bottom: AppConstants.spacing12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300],
          child: Icon(
            isActive ? LucideIcons.check : LucideIcons.cloud,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                config.label,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isActive)
              Padding(
                padding: AppConstants.paddingOnly(left: AppConstants.spacing8),
                child: Chip(
                  label: Text(
                    AppLocalization.settingsServersActive.tr(),
                    style: const TextStyle(fontSize: 10),
                  ),
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
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                tooltip: AppLocalization.settingsServersSetActive.tr(),
                onPressed: () => _handleSetActive(config.id),
              ),
            IconButton(
              icon: const Icon(LucideIcons.pencil),
              tooltip: 'Edit',
              onPressed: () => _showEditApiModal(context, config),
            ),
            if (canDelete)
              IconButton(
                icon: const Icon(LucideIcons.trash2),
                tooltip: AppLocalization.settingsServersDelete.tr(),
                color: Colors.red,
                onPressed: () => _handleDelete(context, config),
              ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _showAddApiModal(BuildContext context) {
    ApiConfigurationModal.show(
      context,
      onSave: (url, label) {
        ref
            .read(connectionGuardProvider.notifier)
            .addApiConfiguration(url, label, setAsActive: true);
      },
    );
  }

  void _showEditApiModal(BuildContext context, ApiConfiguration config) {
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

  void _handleSetActive(String configurationId) {
    ref
        .read(connectionGuardProvider.notifier)
        .setActiveApiConfiguration(configurationId);
  }

  Future<void> _handleDelete(
    BuildContext context,
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
