import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/modals/configurable_modal.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/features/settings/data/tmdb_settings_provider.dart';

class TmdbApiKeyModal {
  static Future<bool?> show(BuildContext context, WidgetRef ref) async {
    String? initialApiKey;
    final currentApiKeyAsync = ref.read(tmdbSettingsProvider);
    currentApiKeyAsync.whenData((data) {
      initialApiKey = data;
    });

    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showConfigurableModal<bool>(
      context: rootContext,
      config: _createConfig(ref, initialApiKey),
      initialValues: {'apiKey': initialApiKey ?? ''},
    );
  }

  static ModalConfig _createConfig(WidgetRef ref, String? currentApiKey) {
    final hasExistingKey = currentApiKey != null && currentApiKey.isNotEmpty;

    return ModalConfig(
      title: 'TMDB API Key',
      banners: hasExistingKey
          ? []
          : const [
              ModalBannerConfig(
                message:
                    'Enter your TMDB API key to enable library management features.',
                type: SettingsModalBannerType.info,
              ),
            ],
      fields: [
        ModalFieldConfig(
          key: 'apiKey',
          label: 'API Key',
          hintText: 'Enter your TMDB API key',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'API key cannot be empty';
            }
            return null;
          },
          suffixWidget: Text(
            'Get your API key from: https://www.themoviedb.org/settings/api',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
      actions: [
        if (hasExistingKey)
          ModalActionConfig(
            label: 'Clear',
            variant: DButtonVariant.danger,
            size: DButtonSize.sm,
            shouldShow: (_, __) => hasExistingKey,
            onTap: (values, state, context) async {
              await ref.read(tmdbSettingsProvider.notifier).clearApiKey();
              if (context.mounted) Navigator.of(context).pop(false);
            },
          ),
        ModalActionConfig(
          label: hasExistingKey ? 'Update' : 'Save',
          icon: Icons.key,
          variant: DButtonVariant.primary,
          size: DButtonSize.sm,
          onTap: (values, state, context) async {
            final apiKey = values['apiKey']?.trim() ?? '';
            await ref.read(tmdbSettingsProvider.notifier).setApiKey(apiKey);
            if (context.mounted) Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

class TmdbRequiredModal {
  static Future<void> show(BuildContext context, WidgetRef ref) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showConfigurableModal(
      context: rootContext,
      config: ModalConfig(
        title: 'TMDB API Key Required',
        banners: const [
          ModalBannerConfig(
            message:
                'You need to configure your TMDB API key before adding '
                'library items. This ensures proper metadata fetching for movies and TV shows.',
            type: SettingsModalBannerType.warning,
          ),
        ],
        fields: const [],
        actions: [
          ModalActionConfig(
            label: 'Configure',
            icon: Icons.key,
            variant: DButtonVariant.primary,
            size: DButtonSize.sm,
            onTap: (_, __, modalContext) async {
              if (modalContext.mounted) Navigator.of(modalContext).pop();
              await TmdbApiKeyModal.show(context, ref);
            },
          ),
        ],
      ),
    );
  }
}
