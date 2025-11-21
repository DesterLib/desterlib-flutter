import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localization.dart';
import '../../../../app/providers/connection_guard_provider.dart';
import '../../domain/entities/connection_status.dart';

/// Platform-adaptive modal/drawer for connection status
/// Shows as modal on desktop, bottom drawer on mobile
class ConnectionStatusModal extends ConsumerWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const ConnectionStatusModal({super.key, this.onRetry, this.onClose});

  bool get _isDesktop {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionGuardProvider);
    final status = connectionState.status;
    final errorMessage = connectionState.errorMessage;
    final apiUrl = connectionState.apiUrl;

    if (_isDesktop) {
      return _buildDesktopModal(context, status, errorMessage, apiUrl, ref);
    } else {
      return _buildMobileDrawer(context, status, errorMessage, apiUrl, ref);
    }
  }

  Widget _buildDesktopModal(
    BuildContext context,
    ConnectionStatus status,
    String? errorMessage,
    String? apiUrl,
    WidgetRef ref,
  ) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildStatusContent(status, errorMessage, apiUrl),
            const SizedBox(height: 24),
            _buildActions(context, status, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(
    BuildContext context,
    ConnectionStatus status,
    String? errorMessage,
    String? apiUrl,
    WidgetRef ref,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    _buildStatusContent(status, errorMessage, apiUrl),
                    const SizedBox(height: 24),
                    _buildActions(context, status, ref),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalization.connectionStatus.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildStatusContent(
    ConnectionStatus status,
    String? errorMessage,
    String? apiUrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusIndicator(status),
        const SizedBox(height: 16),
        if (apiUrl != null) ...[
          Text(
            '${AppLocalization.apiUrl.tr()}:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(apiUrl, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 16),
        ],
        if (errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red[900], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
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
        icon = Icons.check_circle;
        color = Colors.green;
        label = AppLocalization.connected.tr();
        break;
      case ConnectionStatus.disconnected:
        icon = Icons.wifi_off;
        color = Colors.orange;
        label = AppLocalization.disconnected.tr();
        break;
      case ConnectionStatus.error:
        icon = Icons.error;
        color = Colors.red;
        label = AppLocalization.connectionError.tr();
        break;
      case ConnectionStatus.checking:
        icon = Icons.sync;
        color = Colors.blue;
        label = AppLocalization.checking.tr();
        break;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    ConnectionStatus status,
    WidgetRef ref,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (status != ConnectionStatus.connected)
          ElevatedButton.icon(
            onPressed:
                onRetry ??
                () {
                  ref.read(connectionGuardProvider.notifier).checkConnection();
                },
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalization.retry.tr()),
          ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onClose ?? () => Navigator.of(context).pop(),
          child: Text(AppLocalization.close.tr()),
        ),
      ],
    );
  }

  /// Show the connection status modal/drawer
  static void show(
    BuildContext context, {
    VoidCallback? onRetry,
    VoidCallback? onClose,
  }) {
    final isDesktop =
        Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    if (isDesktop) {
      showDialog(
        context: context,
        builder: (context) => ConnectionStatusModal(
          onRetry: onRetry,
          onClose: onClose ?? () => Navigator.of(context).pop(),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ConnectionStatusModal(
          onRetry: onRetry,
          onClose: onClose ?? () => Navigator.of(context).pop(),
        ),
      );
    }
  }
}
