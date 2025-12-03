// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/features/connection/domain/entities/connection_status.dart';
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/m_base_modal.dart';
import 'package:dester/core/widgets/d_icon.dart';

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
        AppConstants.spacingY(AppConstants.spacingMd),
        // Details container
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                _buildDetailItem(
                  context,
                  label: 'Server',
                  value: label,
                  icon: DIconName.tag,
                  isFirst: true,
                ),
              _buildDetailItem(
                context,
                label: AppLocalization.settingsServersApiUrl.tr(),
                value: apiUrl ?? 'Not configured',
                icon: DIconName.server,
                isFirst: label == null,
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...[
          AppConstants.spacingY(AppConstants.spacingMd),
          _buildErrorMessage(errorMessage),
        ],
        if (status != ConnectionStatus.connected &&
            apiUrl != null &&
            apiUrl.isNotEmpty) ...[
          AppConstants.spacingY(AppConstants.spacingMd),
          _buildRetryButton(ref),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator(ConnectionStatus status) {
    DIconName icon;
    Color color;
    String label;
    bool isAnimated = false;

    switch (status) {
      case ConnectionStatus.connected:
        icon = DIconName.link2;
        color = AppConstants.successColor;
        label = AppLocalization.settingsServersConnected.tr();
        break;
      case ConnectionStatus.disconnected:
        icon = DIconName.link2Off;
        color = AppConstants.warningColor;
        label = AppLocalization.settingsServersDisconnected.tr();
        break;
      case ConnectionStatus.error:
        icon = DIconName.error;
        color = AppConstants.dangerColor;
        label = AppLocalization.settingsServersError.tr();
        break;
      case ConnectionStatus.checking:
        icon = DIconName.refreshCw;
        color = AppConstants.infoColor;
        label = AppLocalization.settingsServersChecking.tr();
        isAnimated = true;
        break;
    }

    return Container(
      padding: AppConstants.padding(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        children: [
          isAnimated
              ? TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1500),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 2 * 3.14159,
                      child: DIcon(icon: icon, size: 24, color: color),
                    );
                  },
                  onEnd: () {
                    // Restart animation if still checking
                    if (status == ConnectionStatus.checking) {
                      // This will be handled by the rebuild
                    }
                  },
                )
              : DIcon(icon: icon, size: 24, color: color),
          AppConstants.spacingX(AppConstants.spacing12),
          Expanded(
            child: Text(
              label,
              style: AppTypography.titleSmall(
                color: color,
              ).copyWith(fontWeight: AppTypography.weightMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required String label,
    required String value,
    required DIconName icon,
    required bool isFirst,
  }) {
    return Container(
      padding: AppConstants.paddingX(AppConstants.spacing16),
      child: Row(
        children: [
          DIcon(
            icon: icon,
            size: 24,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
          ),
          AppConstants.spacingX(AppConstants.spacing8),
          Expanded(
            child: Container(
              height: 56,
              alignment: Alignment.centerLeft,
              decoration: isFirst
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  AppConstants.spacingY(AppConstants.spacing2),
                  Text(value, style: AppTypography.titleSmall()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String errorMessage) {
    return Container(
      padding: AppConstants.padding(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppConstants.dangerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DIcon(
            icon: DIconName.error,
            color: AppConstants.dangerColor,
            size: 20,
          ),
          AppConstants.spacingX(AppConstants.spacing8),
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
        icon: DIcon(icon: DIconName.refreshCw, size: 20, color: Colors.white),
        label: Text(AppLocalization.homeRetry.tr()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.accentColor,
          foregroundColor: Colors.white,
          padding: AppConstants.paddingY(AppConstants.spacing12),
        ),
      ),
    );
  }
}
