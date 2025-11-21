import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localization.dart';
import '../../../../app/providers/connection_guard_provider.dart';
import '../../domain/entities/connection_status.dart';

/// Platform-adaptive modal/drawer for connection status
/// Shows as modal on desktop, bottom drawer on mobile
class ConnectionStatusModal extends ConsumerStatefulWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const ConnectionStatusModal({super.key, this.onRetry, this.onClose});

  @override
  ConsumerState<ConnectionStatusModal> createState() =>
      _ConnectionStatusModalState();

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

class _ConnectionStatusModalState extends ConsumerState<ConnectionStatusModal> {
  final _urlController = TextEditingController();
  bool _isSaving = false;

  bool get _isDesktop {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionGuardProvider);
    final status = connectionState.status;
    final errorMessage = connectionState.errorMessage;
    final apiUrl = connectionState.apiUrl;

    // Initialize or update text field with current API URL
    if (_urlController.text.isEmpty && apiUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _urlController.text = apiUrl;
        }
      });
    } else if (apiUrl != null && apiUrl != _urlController.text && !_isSaving) {
      // Only update if URL changed externally and we're not currently saving
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _urlController.text = apiUrl;
        }
      });
    }

    if (_isDesktop) {
      return _buildDesktopModal(context, status, errorMessage, apiUrl);
    } else {
      return _buildMobileDrawer(context, status, errorMessage, apiUrl);
    }
  }

  Widget _buildDesktopModal(
    BuildContext context,
    ConnectionStatus status,
    String? errorMessage,
    String? apiUrl,
  ) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildStatusContent(status, errorMessage, apiUrl),
              const SizedBox(height: 24),
              _buildApiUrlInput(context),
              const SizedBox(height: 24),
              _buildActions(context, status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(
    BuildContext context,
    ConnectionStatus status,
    String? errorMessage,
    String? apiUrl,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                    _buildApiUrlInput(context),
                    const SizedBox(height: 24),
                    _buildActions(context, status),
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
    final connectionState = ref.watch(connectionGuardProvider);
    final isConnected = connectionState.status == ConnectionStatus.connected;
    
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
          onPressed: isConnected
              ? (widget.onClose ?? () => Navigator.of(context).pop())
              : null,
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

  Widget _buildApiUrlInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalization.enterApiUrl.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _urlController,
          builder: (context, value, child) {
            return TextField(
              controller: _urlController,
              enabled: !_isSaving,
              decoration: InputDecoration(
                hintText: 'https://api.example.com',
                border: const OutlineInputBorder(),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _isSaving
                            ? null
                            : () {
                                setState(() {
                                  _urlController.clear();
                                });
                              },
                      )
                    : null,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleSave(context),
            );
          },
        ),
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

  Widget _buildActions(BuildContext context, ConnectionStatus status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (status != ConnectionStatus.connected)
          ElevatedButton.icon(
            onPressed: _isSaving
                ? null
                : (widget.onRetry ??
                      () {
                        ref
                            .read(connectionGuardProvider.notifier)
                            .checkConnection();
                      }),
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalization.retry.tr()),
          ),
        if (status != ConnectionStatus.connected) const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _isSaving ? null : () => _handleSave(context),
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(AppLocalization.save.tr()),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: (_isSaving || status != ConnectionStatus.connected)
              ? null
              : (widget.onClose ?? () => Navigator.of(context).pop()),
          child: Text(AppLocalization.close.tr()),
        ),
      ],
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(connectionGuardProvider.notifier).setApiUrl(url);
      // Optionally close the modal after successful save
      // Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
