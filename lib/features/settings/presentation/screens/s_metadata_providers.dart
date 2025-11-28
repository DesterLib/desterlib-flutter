// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_icon.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/usecases/get_settings.dart';
import 'package:dester/features/settings/domain/usecases/update_settings.dart';
import 'package:dester/features/settings/presentation/mixins/settings_update_mixin.dart';
import 'package:dester/features/settings/presentation/widgets/m_tmdb_api_key.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_item.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';
import 'package:dester/features/settings/settings_feature.dart';

/// Provider for GetSettings use case
final getSettingsProvider = Provider<GetSettings>((ref) {
  return SettingsFeature.createGetSettingsLegacy();
});

/// Provider for UpdateSettings use case
final updateSettingsProvider = Provider<UpdateSettings>((ref) {
  return SettingsFeature.createUpdateSettingsLegacy();
});

/// Provider for current settings
final settingsProvider = FutureProvider<Settings>((ref) async {
  final getSettings = ref.watch(getSettingsProvider);
  final result = await getSettings();
  return result.fold(
    onSuccess: (settings) => settings,
    onFailure: (failure) => throw failure,
  );
});

/// Screen for managing metadata providers
class MetadataProvidersScreen extends ConsumerStatefulWidget {
  const MetadataProvidersScreen({super.key});

  @override
  ConsumerState<MetadataProvidersScreen> createState() =>
      _MetadataProvidersScreenState();
}

class _MetadataProvidersScreenState
    extends ConsumerState<MetadataProvidersScreen>
    with SettingsUpdateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DAppBar(
            title: AppLocalization.settingsMetadataTitle.tr(),
            isCompact: true,
          ),
          SliverPadding(
            padding: AppConstants.padding(AppConstants.spacing16),
            sliver: SliverToBoxAdapter(
              child: DSidebarSpace(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Description
                    Padding(
                      padding: AppConstants.paddingX(AppConstants.spacing16),
                      child: Text(
                        AppLocalization.settingsMetadataDescription.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing16),
                    // Metadata Providers Section
                    SettingsSection(
                      title: AppLocalization.settingsMetadataProvidersTitle
                          .tr(),
                      group: ref
                          .watch(settingsProvider)
                          .when(
                            data: (settings) => SettingsGroup(
                              children: [
                                // TMDB Provider
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.database,
                                    strokeWidth: 2.0,
                                  ),
                                  leadingIconColor: settings.hasMetadataProvider
                                      ? AppConstants.successColor
                                      : AppConstants.warningColor,
                                  title: AppLocalization
                                      .settingsMetadataProviderTmdb
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                    strokeWidth: 2.0,
                                  ),
                                  onTap: () =>
                                      _showTmdbApiKeyModal(context, settings),
                                  isFirst: true,
                                ),
                                // Future providers can be added here
                                // SettingsItem(
                                //   leadingIcon: getIconDataFromDIconName(
                                //     DIconName.database,
                                //     strokeWidth: 2.0,
                                //   ),
                                //   title: 'TVDB',
                                //   trailingText: 'Not configured',
                                //   trailingIcon: getIconDataFromDIconName(
                                //     DIconName.chevronRight,
                                //     strokeWidth: 2.0,
                                //   ),
                                //   onTap: () {
                                //     // Navigate to TVDB configuration
                                //   },
                                // ),
                              ],
                            ),
                            loading: () => SettingsGroup(
                              children: [
                                SettingsItem(
                                  title: AppLocalization
                                      .settingsMetadataProviderTmdb
                                      .tr(),
                                  isFirst: true,
                                ),
                              ],
                            ),
                            error: (error, stack) => SettingsGroup(
                              children: [
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.error,
                                    strokeWidth: 2.0,
                                  ),
                                  title: AppLocalization
                                      .settingsMetadataProviderTmdb
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                    strokeWidth: 2.0,
                                  ),
                                  onTap: () => _showTmdbApiKeyModal(
                                    context,
                                    const Settings(firstRun: true),
                                  ),
                                  isFirst: true,
                                ),
                              ],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTmdbApiKeyModal(BuildContext context, Settings settings) {
    TmdbApiKeyModal.show(
      context,
      initialApiKey: settings.tmdbApiKey,
      onSave: (apiKey) async {
        immediateUpdateSettings(
          fieldName: 'tmdbApiKey',
          updateFn: () async {
            final updateSettings = ref.read(updateSettingsProvider);
            return await updateSettings(tmdbApiKey: apiKey);
          },
          onSuccess: () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalization.settingsMetadataProviderSaved.tr(),
                  ),
                  backgroundColor: AppConstants.successColor,
                ),
              );
            }
          },
          onFailure: (message) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppConstants.dangerColor,
                ),
              );
            }
          },
          providerToInvalidate: settingsProvider,
        );
      },
    );
  }
}
