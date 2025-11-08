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

            // Validate URL is not empty
            if (url.isEmpty) {
              state['hasError'] = true;
              throw Exception('Please enter a server URL');
            }

            // Clear previous error state when starting new attempt
            state['hasError'] = false;

            // Get container from context BEFORE any async operations
            final container = ProviderScope.containerOf(context);

            try {
              // Save the URL first
              await ApiConfig.saveBaseUrl(url);

              // Read all providers from the container
              final baseUrlNotifier = container.read(baseUrlProvider.notifier);
              final connectionNotifier = container.read(
                connectionStatusProvider.notifier,
              );
              final tmdbNotifier = container.read(
                tmdbSettingsProvider.notifier,
              );

              // Update URL (this will rebuild the OpenAPI client)
              baseUrlNotifier.updateUrl(url);

              // Check connection and get the result directly
              final connectionStatus = await connectionNotifier
                  .checkConnection();

              if (!context.mounted) return;

              // Use the returned connection status
              if (connectionStatus == ConnectionStatus.connected) {
                // Try to refresh TMDB settings in the background
                try {
                  await tmdbNotifier.refresh();
                } catch (e) {
                  // Ignore errors during refresh, we're already connected
                }

                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              } else {
                state['hasError'] = true;
                throw Exception('Failed to connect to API server');
              }
            } catch (e) {
              state['hasError'] = true;
              rethrow;
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
