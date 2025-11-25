// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/connection/domain/entities/connection_status.dart';
import 'package:dester/core/connection/presentation/widgets/m_connection_status.dart';
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/usecases/get_settings.dart';
import 'package:dester/features/settings/domain/usecases/update_settings.dart';
import 'package:dester/features/settings/presentation/widgets/m_tmdb_api_key.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_item.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';
import 'package:dester/features/settings/settings_feature.dart';

/// Provider for GetSettings use case
final getSettingsProvider = Provider<GetSettings>((ref) {
  return SettingsFeature.createGetSettings();
});

/// Provider for UpdateSettings use case
final updateSettingsProvider = Provider<UpdateSettings>((ref) {
  return SettingsFeature.createUpdateSettings();
});

/// Provider for current settings
final settingsProvider = FutureProvider<Settings>((ref) async {
  final getSettings = ref.watch(getSettingsProvider);
  return await getSettings();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionGuardProvider);
    final status = connectionState.status;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DAppBar(title: AppLocalization.settingsTitle.tr(), leftAligned: true),
          SliverPadding(
            padding: AppConstants.padding(AppConstants.spacing16),
            sliver: SliverToBoxAdapter(
              child: DSidebarSpace(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Servers Section
                    SettingsSection(
                      title: AppLocalization.settingsServersTitle.tr(),
                      group: SettingsGroup(
                        children: [
                          SettingsItem(
                            leadingIcon: _getStatusIcon(status),
                            leadingIconColor: _getStatusColor(status),
                            title: AppLocalization
                                .settingsServersConnectionStatus
                                .tr(),
                            trailingIcon: LucideIcons.chevronRight300,
                            onTap: () {
                              ConnectionStatusModal.show(context);
                            },
                            isFirst: true,
                          ),
                          SettingsItem(
                            leadingIcon: LucideIcons.server300,
                            title: AppLocalization.settingsServersManageServers
                                .tr(),
                            trailingIcon: LucideIcons.chevronRight300,
                            onTap: () {
                              context.pushNamed('manage-apis');
                            },
                          ),
                        ],
                      ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing24),
                    // TMDB Settings Section
                    SettingsSection(
                      title: AppLocalization.settingsTmdbTitle.tr(),
                      group: ref
                          .watch(settingsProvider)
                          .when(
                            data: (settings) => SettingsGroup(
                              children: [
                                SettingsItem(
                                  leadingIcon: LucideIcons.key300,
                                  title: AppLocalization.settingsTmdbApiKey
                                      .tr(),
                                  trailingIcon: LucideIcons.chevronRight300,
                                  onTap: () => _showTmdbApiKeyModal(
                                    context,
                                    ref,
                                    settings,
                                  ),
                                  isFirst: true,
                                ),
                              ],
                            ),
                            loading: () => SettingsGroup(
                              children: [
                                SettingsItem(
                                  title: AppLocalization.settingsTmdbApiKey
                                      .tr(),
                                  isFirst: true,
                                ),
                              ],
                            ),
                            error: (error, stack) => SettingsGroup(
                              children: [
                                SettingsItem(
                                  leadingIcon: Icons.error_outline,
                                  title: AppLocalization.settingsTmdbApiKey
                                      .tr(),
                                  trailingIcon: LucideIcons.chevronRight300,
                                  onTap: () => _showTmdbApiKeyModal(
                                    context,
                                    ref,
                                    const Settings(firstRun: true),
                                  ),
                                  isFirst: true,
                                ),
                              ],
                            ),
                          ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing24),
                    // Library Settings Section
                    SettingsSection(
                      title: AppLocalization.settingsLibrariesTitle.tr(),
                      group: SettingsGroup(
                        children: [
                          SettingsItem(
                            leadingIcon: LucideIcons.library300,
                            title: AppLocalization
                                .settingsLibrariesManageLibraries
                                .tr(),
                            trailingIcon: LucideIcons.chevronRight300,
                            onTap: () {
                              context.pushNamed('manage-libraries');
                            },
                            isFirst: true,
                          ),
                        ],
                      ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return LucideIcons.link2300;
      case ConnectionStatus.disconnected:
        return LucideIcons.link2Off300;
      case ConnectionStatus.checking:
        return LucideIcons.refreshCw;
      case ConnectionStatus.error:
        return Icons.error;
    }
  }

  Color _getStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return AppConstants.successColor;
      case ConnectionStatus.disconnected:
        return AppConstants.warningColor;
      case ConnectionStatus.checking:
        return AppConstants.infoColor;
      case ConnectionStatus.error:
        return AppConstants.dangerColor;
    }
  }

  void _showTmdbApiKeyModal(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
  ) {
    TmdbApiKeyModal.show(
      context,
      initialApiKey: settings.tmdbApiKey,
      onSave: (apiKey) async {
        try {
          final updateSettings = ref.read(updateSettingsProvider);
          await updateSettings(tmdbApiKey: apiKey);
          if (context.mounted) {
            ref.invalidate(settingsProvider);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalization.settingsTmdbApiKeySaved.tr()),
                backgroundColor: AppConstants.successColor,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: AppConstants.dangerColor,
              ),
            );
          }
        }
      },
    );
  }
}
