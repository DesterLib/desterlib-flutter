// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App
import 'package:dester/app/localization/app_localization.dart';
import 'package:dester/app/providers/connection_guard_provider.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_primary_app_bar.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_spinner.dart';

// Features
import 'package:dester/features/settings/domain/usecases/reset_settings.dart';
import 'package:dester/features/settings/presentation/providers/settings_providers.dart';
import 'package:dester/features/settings/presentation/widgets/api_list_widget.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_item.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';
import 'package:dester/features/settings/settings_feature.dart';

/// Provider for ResetAllSettings use case
final resetAllSettingsProvider = Provider<ResetAllSettings>((ref) {
  return SettingsFeature.createResetAllSettingsLegacy();
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
          DPrimaryAppBar(title: AppLocalization.settingsTitle.tr()),
          SliverPadding(
            padding: AppConstants.padding(AppConstants.spacing16),
            sliver: SliverToBoxAdapter(
              child: DSidebarSpace(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Library Settings Section
                    SettingsSection(
                      title: AppLocalization.settingsLibrariesTitle.tr(),
                      group: SettingsGroup(
                        children: [
                          SettingsItem(
                            leadingIcon: getIconDataFromDIconName(
                              DIconName.library,
                            ),
                            title: AppLocalization
                                .settingsLibrariesManageLibraries
                                .tr(),
                            trailingIcon: getIconDataFromDIconName(
                              DIconName.chevronRight,
                            ),
                            onTap: () {
                              context.pushNamed('manage-libraries');
                            },
                            isFirst: true,
                          ),
                        ],
                      ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing24),
                    // Servers Section
                    SettingsSection(
                      title: AppLocalization.settingsServersTitle.tr(),
                      group: SettingsGroup(
                        children: [
                          SettingsItem(
                            leadingIcon: ConnectionStatusHelper.getStatusIcon(
                              status,
                            ),
                            leadingIconColor:
                                ConnectionStatusHelper.getStatusColor(status),
                            title: AppLocalization.settingsServersManageServers
                                .tr(),
                            trailingIcon: getIconDataFromDIconName(
                              DIconName.chevronRight,
                            ),
                            onTap: () {
                              context.pushNamed('manage-apis');
                            },
                            isFirst: true,
                          ),
                        ],
                      ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing24),
                    // Metadata Settings Section
                    SettingsSection(
                      title: AppLocalization.settingsMetadataTitle.tr(),
                      group: ref
                          .watch(settingsProvider)
                          .when(
                            skipLoadingOnRefresh: false,
                            data: (settings) => SettingsGroup(
                              children: [
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.database,
                                  ),
                                  leadingIconColor: settings.hasMetadataProvider
                                      ? AppConstants.successColor
                                      : AppConstants.warningColor,
                                  title: AppLocalization
                                      .settingsMetadataManageProviders
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                  ),
                                  onTap: () {
                                    context.pushNamed('metadata-providers');
                                  },
                                  isFirst: true,
                                ),
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.folderCog,
                                  ),
                                  title: AppLocalization
                                      .settingsScanSettingsTitle
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                  ),
                                  onTap: () {
                                    context.pushNamed('scan-settings');
                                  },
                                ),
                              ],
                            ),
                            loading: () => SettingsGroup(
                              children: [
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.database,
                                  ),
                                  leadingIconColor: Theme.of(
                                    context,
                                  ).iconTheme.color?.withValues(alpha: 0.3),
                                  title: AppLocalization
                                      .settingsMetadataManageProviders
                                      .tr(),
                                  isLoading: true,
                                  isFirst: true,
                                ),
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.folderCog,
                                  ),
                                  title: AppLocalization
                                      .settingsScanSettingsTitle
                                      .tr(),
                                  trailing: const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: DSpinner(),
                                  ),
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
                                      .settingsMetadataManageProviders
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                  ),
                                  onTap: () {
                                    context.pushNamed('metadata-providers');
                                  },
                                  isFirst: true,
                                ),
                                SettingsItem(
                                  leadingIcon: getIconDataFromDIconName(
                                    DIconName.folderCog,
                                  ),
                                  title: AppLocalization
                                      .settingsScanSettingsTitle
                                      .tr(),
                                  trailingIcon: getIconDataFromDIconName(
                                    DIconName.chevronRight,
                                  ),
                                  onTap: () {
                                    context.pushNamed('scan-settings');
                                  },
                                ),
                              ],
                            ),
                          ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing24),
                    // Reset Settings Section
                    SettingsSection(
                      title: AppLocalization.settingsResetTitle.tr(),
                      group: SettingsGroup(
                        helperText: AppLocalization.settingsResetFullHelper
                            .tr(),
                        children: [
                          SettingsItem(
                            leadingIcon: getIconDataFromDIconName(
                              DIconName.refreshCw,
                            ),
                            title: AppLocalization.settingsResetAllSettings
                                .tr(),
                            trailingIcon: getIconDataFromDIconName(
                              DIconName.error,
                            ),
                            onTap: () => _showResetAllDialog(context, ref),
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

  /// Show confirmation dialog and reset all settings
  Future<void> _showResetAllDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.settingsResetConfirmTitle.tr()),
        content: Text(AppLocalization.settingsResetAllConfirmMessage.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalization.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.dangerColor,
            ),
            child: Text(AppLocalization.reset.tr()),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: DSpinner()),
    );

    try {
      final resetAllSettings = ref.read(resetAllSettingsProvider);
      final result = await resetAllSettings();

      if (!context.mounted) return;

      Navigator.of(context).pop(); // Close loading dialog

      result.fold(
        onSuccess: (_) {
          ref.invalidate(settingsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalization.settingsResetAllSuccess.tr()),
              backgroundColor: AppConstants.successColor,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onFailure: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppConstants.dangerColor,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
    } catch (error) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.settingsResetAllError.tr()),
          backgroundColor: AppConstants.dangerColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
