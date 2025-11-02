import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/app/theme/theme.dart';
import '../../../../app/providers.dart';
import '../../../../core/providers/connection_provider.dart';
import '../../../../core/config/api_config.dart';

class ApiConnectionModal {
  static Future<bool?> show(BuildContext context) {
    return showSettingsModal<bool>(
      context: context,
      title: 'API Connection',
      builder: (context) => const _ApiConnectionModalContent(),
    );
  }
}

class _ApiConnectionModalContent extends ConsumerStatefulWidget {
  const _ApiConnectionModalContent();

  @override
  ConsumerState<_ApiConnectionModalContent> createState() =>
      _ApiConnectionModalContentState();
}

class _ApiConnectionModalContentState
    extends ConsumerState<_ApiConnectionModalContent> {
  final TextEditingController _urlController = TextEditingController();
  bool _isConnecting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    await ApiConfig.loadBaseUrl();
    if (mounted) {
      setState(() {
        _urlController.text = ApiConfig.baseUrl;
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    if (!mounted) return;

    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      // Save the new URL
      await ApiConfig.saveBaseUrl(_urlController.text.trim());

      // Update the base URL provider
      ref.read(baseUrlProvider.notifier).updateUrl(_urlController.text.trim());

      // Test the connection
      final connectionNotifier = ref.read(connectionStatusProvider.notifier);
      await connectionNotifier.checkConnection();

      // Wait for status update
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      final status = ref.read(connectionStatusProvider);
      if (status == ConnectionStatus.connected) {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to connect to API server';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Connection error: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_errorMessage != null)
          SettingsModalBanner(
            message: _errorMessage!,
            type: SettingsModalBannerType.error,
          ),
        SettingsModalTextField(
          controller: _urlController,
          label: 'Server URL',
          hintText: 'http://localhost:3001',
          keyboardType: TextInputType.url,
          enabled: !_isConnecting,
        ),
        _ConnectionStatusIndicator(),
        AppSpacing.gapVerticalXS,
        SettingsModalActions(
          actions: [
            DButton(
              label: _isConnecting ? 'Connecting...' : 'Connect',
              variant: DButtonVariant.primary,
              size: DButtonSize.sm,
              icon: Icons.link,
              onTap: _isConnecting ? null : _testConnection,
            ),
          ],
        ),
      ],
    );
  }
}

class _ConnectionStatusIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectionStatusProvider);

    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case ConnectionStatus.connected:
        statusText = 'Connected';
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_outline;
        break;
      case ConnectionStatus.disconnected:
        statusText = 'Disconnected';
        statusColor = AppColors.error;
        statusIcon = Icons.error_outline;
        break;
      case ConnectionStatus.checking:
        statusText = 'Checking connection...';
        statusColor = AppColors.warning;
        statusIcon = Icons.sync;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: AppRadius.radiusSM,
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
