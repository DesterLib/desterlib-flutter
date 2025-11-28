// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/m_base_modal.dart';

/// Platform-adaptive modal/drawer for connection status
/// Shows connection details: status, IP/URL, and label name
class ConnectionStatusModal extends ConsumerWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const ConnectionStatusModal({super.key, this.onRetry, this.onClose});

  /// Show the connection status modal/drawer
  static void show(
    BuildContext context, {
    VoidCallback? onRetry,
    VoidCallback? onClose,
  }) {
    final modal = ConnectionStatusModal(
      onRetry: onRetry,
      onClose:
          onClose ?? () => Navigator.of(context, rootNavigator: true).pop(),
    );

    BaseModal.show(
      context,
      title: AppLocalization.settingsServersConnectionStatus.tr(),
      content: modal,
      onClose:
          onClose ?? () => Navigator.of(context, rootNavigator: true).pop(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionGuardProvider);
    final status = connectionState.status;
    final errorMessage = connectionState.errorMessage;
    final apiUrl = connectionState.apiUrl;

    // Get the active API configuration to display the label
    final apiConfigurations = ref
        .read(connectionGuardProvider.notifier)
        .getApiConfigurations();
    final activeConfig = apiConfigurations
        .where((config) => config.isActive)
        .firstOrNull;
    final label = activeConfig?.label;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStatusIndicator(status),
        AppConstants.spacingY(AppConstants.spacingLg),
        if (label != null) ...[
          _buildDetailItem(
            context,
            label: 'Server',
            value: label,
            icon: LucideIcons.tag300,
          ),
          AppConstants.spacingY(AppConstants.spacingMd),
        ],
        _buildDetailItem(
          context,
          label: AppLocalization.settingsServersApiUrl.tr(),
          value: apiUrl ?? 'Not configured',
          icon: LucideIcons.server300,
        ),
        if (errorMessage != null) ...[
          AppConstants.spacingY(AppConstants.spacingMd),
          _buildErrorMessage(errorMessage),
        ],
        if (status != ConnectionStatus.connected &&
            apiUrl != null &&
            apiUrl.isNotEmpty) ...[
          AppConstants.spacingY(AppConstants.spacingLg),
          _buildRetryButton(ref),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator(ConnectionStatus status) {
    IconData icon;
    Color color;
    String label;

    switch (status) {
      case ConnectionStatus.connected:
        icon = LucideIcons.link2300;
        color = AppConstants.successColor;
        label = AppLocalization.settingsServersConnected.tr();
        break;
      case ConnectionStatus.disconnected:
        icon = LucideIcons.link2Off300;
        color = AppConstants.warningColor;
        label = AppLocalization.settingsServersDisconnected.tr();
        break;
      case ConnectionStatus.error:
        icon = Icons.error;
        color = AppConstants.dangerColor;
        label = AppLocalization.settingsServersError.tr();
        break;
      case ConnectionStatus.checking:
        icon = LucideIcons.refreshCw;
        color = AppConstants.infoColor;
        label = AppLocalization.settingsServersChecking.tr();
        break;
    }

    return Container(
      padding: AppConstants.padding(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppConstants.iconSizeXl),
          AppConstants.spacingX(AppConstants.spacing12),
          Text(label, style: AppTypography.titleMedium(color: color)),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppConstants.iconSizeMd,
          color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
        ),
        AppConstants.spacingX(AppConstants.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
              AppConstants.spacingY(AppConstants.spacing4),
              Text(
                value,
                style: AppTypography.bodyMedium().copyWith(
                  fontWeight: AppTypography.weightMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String errorMessage) {
    return Container(
      padding: AppConstants.padding(AppConstants.spacing12),
      decoration: BoxDecoration(
        color: AppConstants.dangerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(
          color: AppConstants.dangerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: AppConstants.dangerColor, size: 20),
          AppConstants.spacingX(AppConstants.spacingSm),
          Expanded(
            child: Text(
              errorMessage,
              style: AppTypography.bodySmall(color: AppConstants.dangerColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            onRetry ??
            () {
              ref.read(connectionGuardProvider.notifier).checkConnection();
            },
        icon: const Icon(LucideIcons.refreshCw),
        label: Text(AppLocalization.homeRetry.tr()),
        style: ElevatedButton.styleFrom(
          padding: AppConstants.paddingY(AppConstants.spacing12),
        ),
      ),
    );
  }
}
