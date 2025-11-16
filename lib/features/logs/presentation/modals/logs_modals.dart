import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/modals/configurable_modal.dart';
import 'package:dester/shared/widgets/modals/d_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/core/providers/logs_provider.dart';
import 'package:dester/core/services/websocket_service.dart';

class ClearLogsModal {
  static Future<bool?> show(BuildContext context, WidgetRef ref) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showConfigurableModal<bool>(
      context: rootContext,
      config: _createConfig(ref),
    );
  }

  static ModalConfig _createConfig(WidgetRef ref) {
    return ModalConfig(
      title: 'Clear Logs',
      banners: const [
        ModalBannerConfig(
          message:
              'This will clear all logs from the server and the app. This action cannot be undone.',
          type: DModalBannerType.warning,
          icon: Icons.warning_amber_outlined,
        ),
      ],
      fields: const [],
      actions: [
        ModalActionConfig(
          label: 'Clear All Logs',
          variant: DButtonVariant.danger,
          size: DButtonSize.sm,
          icon: PlatformIcons.delete,
          onTap: (values, state, context) async {
            await ref.read(logsProvider.notifier).clearAllLogs();
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
    );
  }
}

class LogDetailsModal {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    LogMessage log,
  ) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showConfigurableModal(
      context: rootContext,
      config: _createConfig(log),
    );
  }

  static ModalConfig _createConfig(LogMessage log) {
    final hasMetadata = log.meta != null && (log.meta as Map).isNotEmpty;

    return ModalConfig(
      title: 'Log Details',
      fields: const [],
      customSections: [
        ModalSectionConfig(
          position: 0,
          builder: (context, state, updateState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DetailRow(label: 'Timestamp', value: log.timestamp),
                AppSpacing.gapVerticalMD,
                _DetailRow(label: 'Level', value: log.level.toUpperCase()),
                AppSpacing.gapVerticalMD,
                _DetailRow(label: 'Message', value: log.message),
                if (hasMetadata) ...[
                  AppSpacing.gapVerticalLG,
                  Text(
                    'Metadata',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.gapVerticalMD,
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: SelectableText(
                      log.meta.toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'monospace',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
      actions: [
        ModalActionConfig(
          label: 'Copy to Clipboard',
          variant: DButtonVariant.secondary,
          size: DButtonSize.sm,
          icon: Icons.copy,
          onTap: (values, state, context) async {
            final text = hasMetadata
                ? '${log.timestamp} [${log.level.toUpperCase()}]: ${log.message}\n${log.meta}'
                : '${log.timestamp} [${log.level.toUpperCase()}]: ${log.message}';
            await Clipboard.setData(ClipboardData(text: text));

            // Show feedback
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapVerticalXS,
        SelectableText(
          value,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        ),
      ],
    );
  }
}
