// Dart
import 'dart:async';

// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_bottom_nav_space.dart';
import 'package:dester/core/widgets/d_button.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_icon_button.dart';
import 'package:dester/core/widgets/d_popup_menu.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/empty_state_widget.dart';
import 'package:dester/core/websocket/websocket_provider.dart';

// Features
import 'package:dester/features/connection/connection_feature.dart';
import 'package:dester/features/connection/domain/entities/api_configuration.dart';
import 'package:dester/features/connection/domain/entities/api_health.dart';
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/features/connection/presentation/widgets/m_api_configuration.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';

/// Connection status UI helpers - shared across connection-related widgets
class ConnectionStatusHelper {
  ConnectionStatusHelper._();

  /// Get icon for connection status
  static IconData getStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return getIconDataFromDIconName(DIconName.cloudCheck, strokeWidth: 2.0);
      case ConnectionStatus.disconnected:
        return getIconDataFromDIconName(DIconName.cloudOff, strokeWidth: 2.0);
      case ConnectionStatus.checking:
        return getIconDataFromDIconName(DIconName.refreshCw, strokeWidth: 2.0);
      case ConnectionStatus.error:
        return getIconDataFromDIconName(DIconName.error, strokeWidth: 2.0);
    }
  }

  /// Get color for connection status
  static Color getStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return AppConstants.successColor;
      case ConnectionStatus.disconnected:
        return AppConstants.warningColor;
      case ConnectionStatus.checking:
        return AppConstants.infoColor;
      case ConnectionStatus.error:
        return AppConstants.dangerColor;
    }
  }

  /// Get icon for API health status
  static IconData getHealthIcon(
    ApiHealthStatus status, {
    bool isActive = false,
  }) {
    switch (status) {
      case ApiHealthStatus.healthy:
        return getIconDataFromDIconName(DIconName.cloudCheck, strokeWidth: 2.0);
      case ApiHealthStatus.unhealthy:
        return getIconDataFromDIconName(DIconName.cloudOff, strokeWidth: 2.0);
      case ApiHealthStatus.checking:
        return getIconDataFromDIconName(DIconName.refreshCw, strokeWidth: 2.0);
      case ApiHealthStatus.idle:
        // Idle means no health data - always show grey cloud
        // Active status is separate from health status
        return getIconDataFromDIconName(DIconName.cloud, strokeWidth: 2.0);
    }
  }

  /// Get color for API health status
  static Color getHealthColor(
    BuildContext context,
    ApiHealthStatus status, {
    bool isActive = false,
  }) {
    switch (status) {
      case ApiHealthStatus.healthy:
        return AppConstants.successColor;
      case ApiHealthStatus.unhealthy:
        return AppConstants.dangerColor;
      case ApiHealthStatus.checking:
        return Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ??
            Colors.grey;
      case ApiHealthStatus.idle:
        // Idle means no health data - always show grey
        // Active status is separate from health status
        return Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ??
            Colors.grey;
    }
  }
}

/// API configuration card widget matching the SettingsItem/LibraryCard pattern
class ApiConfigCard extends ConsumerStatefulWidget {
  final ApiConfiguration config;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetActive;
  final bool isFirst;

  const ApiConfigCard({
    super.key,
    required this.config,
    required this.onEdit,
    required this.onDelete,
    this.onSetActive,
    this.isFirst = false,
  });

  @override
  ConsumerState<ApiConfigCard> createState() => _ApiConfigCardState();
}

class _ApiConfigCardState extends ConsumerState<ApiConfigCard> {
  ApiHealthStatus _healthStatus = ApiHealthStatus.idle;
  late final _checkApiHealth = ConnectionFeature.createCheckApiHealth();

  @override
  void initState() {
    super.initState();
    // For inactive servers, check health once on mount
    // Active server uses WebSocket health status (see build method)
    if (!widget.config.isActive) {
      _checkHealth();
    }
  }

  Future<void> _checkHealth() async {
    final url = widget.config.url;
    if (url.isEmpty) {
      setState(() => _healthStatus = ApiHealthStatus.idle);
      return;
    }

    setState(() => _healthStatus = ApiHealthStatus.checking);

    final result = await _checkApiHealth(url);

    if (mounted) {
      setState(() => _healthStatus = result.status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.config.isActive;

    // For active server: watch WebSocket health status to trigger rebuilds
    // The actual status is retrieved in helper methods via _getCurrentHealthStatus
    if (isActive) {
      ref.watch(healthStatusProvider);
    }

    // Build trailing menu button with ellipsis using DPopupMenu
    final trailingWidget = DPopupMenu<String>(
      icon: DIconName.ellipsis,
      size: DIconButtonSize.sm,
      variant: DIconButtonVariant.secondary,
      onSelected: (value) {
        if (value == 'edit') {
          widget.onEdit();
        } else if (value == 'delete') {
          widget.onDelete();
        } else if (value == 'set_active') {
          widget.onSetActive?.call();
        }
      },
      items: [
        if (!isActive)
          DPopupMenuItem<String>(
            value: 'set_active',
            child: Row(
              children: [
                Icon(
                  getIconDataFromDIconName(DIconName.check, strokeWidth: 2.0),
                ),
                const SizedBox(width: AppConstants.spacing8),
                Text(AppLocalization.settingsServersSetActive.tr()),
              ],
            ),
          ),
        DPopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(getIconDataFromDIconName(DIconName.edit, strokeWidth: 2.0)),
              const SizedBox(width: AppConstants.spacing8),
              const Text('Edit'),
            ],
          ),
        ),
        DPopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                getIconDataFromDIconName(DIconName.trash, strokeWidth: 2.0),
                color: Colors.red,
              ),
              const SizedBox(width: AppConstants.spacing8),
              Text(
                AppLocalization.settingsServersDelete.tr(),
                style: AppTypography.bodyMedium(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );

    // Build content matching SettingsItem structure
    return Container(
      padding: AppConstants.paddingX(AppConstants.spacing16),
      child: Row(
        children: [
          _buildLeadingIcon(context, isActive),
          SizedBox(width: AppConstants.spacing8),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 56),
              alignment: Alignment.centerLeft,
              decoration: widget.isFirst
                  ? null
                  : BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
              child: Padding(
                padding: AppConstants.paddingY(AppConstants.spacing8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.config.label,
                            style: AppTypography.titleSmall(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppConstants.spacing2),
                          Text(
                            widget.config.url,
                            style: AppTypography.bodySmall().copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Trailing: quick connect + menu
                    _buildTrailingSection(context, isActive, trailingWidget),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build trailing section with quick connect button and menu
  Widget _buildTrailingSection(
    BuildContext context,
    bool isActive,
    Widget menuWidget,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQuickConnectButton(context, isActive),
        SizedBox(width: AppConstants.spacing8),
        menuWidget,
      ],
    );
  }

  /// Get the current health status for display
  ApiHealthStatus _getCurrentHealthStatus(bool isActive) {
    if (isActive) {
      final wsHealth = ref.read(healthStatusProvider);

      if (wsHealth.isHealthy) {
        return ApiHealthStatus.healthy;
      } else if (wsHealth.isDegraded || wsHealth.isUnhealthy) {
        return ApiHealthStatus.unhealthy;
      } else if (wsHealth.isUnknown) {
        return ApiHealthStatus.idle;
      }
    }
    return _healthStatus;
  }

  Widget _buildLeadingIcon(BuildContext context, bool isActive) {
    final currentStatus = _getCurrentHealthStatus(isActive);

    // Show checking spinner
    if (currentStatus == ApiHealthStatus.checking) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ??
                Colors.grey,
          ),
        ),
      );
    }

    final iconColor = ConnectionStatusHelper.getHealthColor(
      context,
      currentStatus,
      isActive: isActive,
    );
    final icon = ConnectionStatusHelper.getHealthIcon(
      currentStatus,
      isActive: isActive,
    );

    return Icon(icon, size: 24, color: iconColor);
  }

  /// Build quick connect button - shows active status with link icon
  /// Green when active, grey when inactive (clickable to activate)
  Widget _buildQuickConnectButton(BuildContext context, bool isActive) {
    final currentStatus = _getCurrentHealthStatus(isActive);
    if (isActive) {
      // Active: show green link icon (not clickable, just indicator)
      return Tooltip(
        message: AppLocalization.settingsServersActive.tr(),
        child: DIconButton(
          icon: DIconName.link2,
          size: DIconButtonSize.sm,
          variant: DIconButtonVariant.secondary,
          color: AppConstants.successColor,
        ),
      );
    }

    // Inactive: show grey link icon (clickable to activate)
    if (widget.onSetActive == null) {
      return const SizedBox.shrink();
    }

    final isHealthy = currentStatus == ApiHealthStatus.healthy;
    final color = isHealthy
        ? AppConstants.successColor.withValues(alpha: 0.5)
        : Theme.of(context).iconTheme.color?.withValues(alpha: 0.3) ??
              Colors.grey;

    return Tooltip(
      message: AppLocalization.settingsServersSetActive.tr(),
      child: DIconButton(
        icon: DIconName.link2Off,
        size: DIconButtonSize.sm,
        variant: DIconButtonVariant.plain,
        color: color,
        onPressed: widget.onSetActive,
      ),
    );
  }
}

class ApiListWidget extends ConsumerWidget {
  final List<ApiConfiguration> configurations;

  const ApiListWidget({super.key, required this.configurations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: configurations.asMap().entries.map((entry) {
        final index = entry.key;
        final config = entry.value;

        return ApiConfigCard(
          config: config,
          isFirst: index == 0,
          onEdit: () => _showEditApiModal(context, ref, config),
          onDelete: () => _handleDelete(context, ref, config),
          onSetActive: config.isActive
              ? null
              : () => _handleSetActive(ref, config.id),
        );
      }).toList(),
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
      onSave: (url, label, {bool isHealthy = false}) {
        // For now, we'll delete and recreate. In the future, we can add an update use case
        ref
            .read(connectionGuardProvider.notifier)
            .deleteApiConfiguration(config.id);
        // For edits: keep active if it was active AND healthy, otherwise respect health check
        final shouldSetActive = config.isActive && isHealthy;
        ref
            .read(connectionGuardProvider.notifier)
            .addApiConfiguration(url, label, setAsActive: shouldSetActive);
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

/// Configuration options for the API configuration content widget
class ApiConfigurationContentOptions {
  /// Whether to wrap content in DSidebarSpace
  final bool withSidebarSpace;

  /// Whether to wrap content in DBottomNavSpace
  final bool withBottomNavSpace;

  const ApiConfigurationContentOptions({
    this.withSidebarSpace = false,
    this.withBottomNavSpace = false,
  });

  /// Configuration for the connection setup screen (initial setup, no navigation)
  const ApiConfigurationContentOptions.connectionSetup()
    : withSidebarSpace = false,
      withBottomNavSpace = false;

  /// Configuration for the API management screen (within app navigation)
  const ApiConfigurationContentOptions.apiManagement()
    : withSidebarSpace = true,
      withBottomNavSpace = true;
}

/// Unified sliver content for displaying and managing API configurations
/// Used by both ConnectionSetupScreen and ApiManagementScreen
/// Note: This returns a list of slivers to be used inside a CustomScrollView
class ApiConfigurationSlivers extends ConsumerWidget {
  final ApiConfigurationContentOptions options;

  const ApiConfigurationSlivers({super.key, required this.options});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the connection state to trigger rebuilds when configurations change
    ref.watch(connectionGuardProvider);

    // Now read the configurations from the notifier
    final configurations = ref
        .read(connectionGuardProvider.notifier)
        .getApiConfigurations();

    // Return a single widget that contains multiple slivers using MultiSliver pattern
    // Since we can't return multiple widgets, we use SliverMainAxisGroup
    if (configurations.isNotEmpty) {
      return SliverPadding(
        padding: AppConstants.padding(AppConstants.spacing16),
        sliver: SliverToBoxAdapter(
          child: _wrapWithSpacing(
            Column(
              children: [
                SettingsSection(
                  title: AppLocalization.settingsServersTitle.tr(),
                  group: SettingsGroup(
                    children: [ApiListWidget(configurations: configurations)],
                  ),
                ),
                if (options.withBottomNavSpace) ...[
                  SizedBox(height: AppConstants.spacing16),
                  const DBottomNavSpace(child: SizedBox.shrink()),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: _wrapEmptyState(
        EmptyStateWidget(
          title: AppLocalization.settingsServersNoApisConfigured.tr(),
          subtitle: AppLocalization.settingsServersAddFirstApi.tr(),
          icon: DIconName.cloud,
          action: DButton(
            onPressed: () => _showAddApiModal(context, ref),
            leadingIcon: DIconName.plus,
            label: AppLocalization.settingsServersAddApi.tr(),
            variant: DButtonVariant.primary,
          ),
        ),
      ),
    );
  }

  /// Wraps the content with sidebar spacing if enabled
  Widget _wrapWithSpacing(Widget child) {
    if (options.withSidebarSpace) {
      return DSidebarSpace(child: child);
    }
    return child;
  }

  /// Wraps the empty state with sidebar and bottom nav spacing if enabled
  Widget _wrapEmptyState(Widget child) {
    Widget result = child;

    if (options.withBottomNavSpace) {
      result = DBottomNavSpace(child: result);
    }

    if (options.withSidebarSpace) {
      result = DSidebarSpace(child: result);
    }

    return result;
  }

  void _showAddApiModal(BuildContext context, WidgetRef ref) {
    ApiConfigurationModal.show(
      context,
      onSave: (url, label, {bool isHealthy = false}) {
        // Only set as active if health check passed
        ref
            .read(connectionGuardProvider.notifier)
            .addApiConfiguration(url, label, setAsActive: isHealthy);
      },
    );
  }
}
