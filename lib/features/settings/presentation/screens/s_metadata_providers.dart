// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_secondary_app_bar.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_icon.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/presentation/providers/settings_providers.dart';
import 'package:dester/features/settings/presentation/widgets/m_tmdb_api_key.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_item.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';

/// Screen for managing metadata providers
class MetadataProvidersScreen extends ConsumerWidget {
  const MetadataProvidersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DSecondaryAppBar(title: AppLocalization.settingsMetadataTitle.tr()),
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
                            skipLoadingOnRefresh: false,
                            data: (settings) => SettingsGroup(
                              children: [
                                // TMDB Provider
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.database,
                                  ),
                                  leadingIconColor: settings.hasMetadataProvider
                                      ? AppConstants.successColor
                                      : AppConstants.warningColor,
                                  title: AppLocalization
                                      .settingsMetadataProviderTmdb
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                  ),
                                  onTap: () => _showTmdbApiKeyModal(
                                    context,
                                    settings,
                                    ref,
                                  ),
                                  isFirst: true,
                                ),
                                // Future providers can be added here
                                // SettingsItem(
                                //   leadingIcon: getIconDataFromDIconName(
                                //     DIconName.database,
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
                                  ),
                                  title: AppLocalization
                                      .settingsMetadataProviderTmdb
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                  ),
                                  onTap: () => _showTmdbApiKeyModal(
                                    context,
                                    const Settings(firstRun: true),
                                    ref,
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

  void _showTmdbApiKeyModal(
    BuildContext context,
    Settings settings,
    WidgetRef ref,
  ) {
    TmdbApiKeyModal.show(
      context,
      initialApiKey: settings.tmdbApiKey,
      onSave: (apiKey) async {
        // Use the notifier's updateField method for proper state management
        try {
          await ref
              .read(settingsNotifierProvider.notifier)
              .updateField(tmdbApiKey: apiKey);

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
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save API key: ${e.toString()}'),
                backgroundColor: AppConstants.dangerColor,
              ),
            );
          }
        }
      },
    );
  }
}
