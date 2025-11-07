import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/modals/configurable_modal.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/app/theme/theme.dart';
import '../../../../app/providers.dart';
import '../../../../core/providers/connection_provider.dart';
import '../../../../core/config/api_config.dart';
import '../../data/tmdb_settings_provider.dart';

class ApiConnectionModal {
  static Future<bool?> show(BuildContext context, WidgetRef ref) async {
    await ApiConfig.loadBaseUrl();

    if (!context.mounted) return null;

    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showConfigurableModal<bool>(
      context: rootContext,
      config: _createConfig(ref),
      initialValues: {'url': ApiConfig.baseUrl},
    );
  }

  static ModalConfig _createConfig(WidgetRef ref) {
    return ModalConfig(
      title: 'API Connection',
      banners: const [],
      fields: [
        ModalFieldConfig(
          key: 'url',
          label: 'Server URL',
          hintText: 'http://localhost:3001',
          keyboardType: TextInputType.url,
        ),
      ],
      customSections: [
        ModalSectionConfig(
          position: 1,
          builder: (context, state, updateState) {
            return _ConnectionStatusIndicator();
          },
        ),
      ],
      actions: [
        ModalActionConfig(
          label: 'Connect',
          icon: Icons.link,
          variant: DButtonVariant.primary,
          size: DButtonSize.sm,
          labelBuilder: (values, state) {
            final hasError = state['hasError'] == true;
            return hasError ? 'Retry' : 'Connect';
          },
          iconBuilder: (values, state) {
            final hasError = state['hasError'] == true;
            return hasError ? Icons.refresh : Icons.link;
          },
          onTap: (values, state, context) async {
            final url = values['url']?.trim() ?? '';

            await ApiConfig.saveBaseUrl(url);
            ref.read(baseUrlProvider.notifier).updateUrl(url);

            final connectionNotifier = ref.read(
              connectionStatusProvider.notifier,
            );
            await connectionNotifier.checkConnection();

            await Future.delayed(const Duration(milliseconds: 200));

            if (!context.mounted) return;

            final status = ref.read(connectionStatusProvider);
            if (status == ConnectionStatus.connected) {
              await ref.read(tmdbSettingsProvider.notifier).refresh();

              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            } else {
              state['hasError'] = true;
              throw Exception('Failed to connect to API server');
            }
          },
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
