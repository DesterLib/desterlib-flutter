// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_secondary_app_bar.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_spinner.dart';

// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/domain/usecases/get_settings.dart';
import 'package:dester/features/settings/domain/usecases/reset_settings.dart';
import 'package:dester/features/settings/domain/usecases/update_settings.dart';
import 'package:dester/features/settings/presentation/mixins/settings_update_mixin.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';
import 'package:dester/features/settings/presentation/widgets/settings_item.dart';
import 'package:dester/features/settings/presentation/widgets/isolated_setting_field.dart';
import 'package:dester/features/settings/settings_feature.dart';

/// Provider for GetSettings use case
final getSettingsProvider = Provider<GetSettings>((ref) {
  return SettingsFeature.createGetSettingsLegacy();
});

/// Provider for UpdateSettings use case
final updateSettingsProvider = Provider<UpdateSettings>((ref) {
  return SettingsFeature.createUpdateSettingsLegacy();
});

/// Provider for ResetScanSettings use case
final resetScanSettingsProvider = Provider<ResetScanSettings>((ref) {
  return SettingsFeature.createResetScanSettingsLegacy();
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

/// Selector provider for scanSettings only - prevents unnecessary rebuilds
/// Only rebuilds when scanSettings changes, not when other settings change
final scanSettingsProvider = FutureProvider<ScanSettings>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  return settings.scanSettings ?? ScanSettings.defaults;
});

/// Screen for managing scan settings
class ScanSettingsScreen extends ConsumerStatefulWidget {
  const ScanSettingsScreen({super.key});

  @override
  ConsumerState<ScanSettingsScreen> createState() => _ScanSettingsScreenState();
}

class _ScanSettingsScreenState extends ConsumerState<ScanSettingsScreen>
    with SettingsUpdateMixin {
  late ScanSettings _scanSettings;
  bool _isResetting = false; // Separate flag for reset operation
  bool _isInitialized = false;
  ScanSettings? _pendingUpdate; // Track pending update to send after debounce

  @override
  void initState() {
    super.initState();
    _scanSettings = ScanSettings.defaults;
    _isInitialized = false;
    // No need to invalidate - provider will load automatically when watched
  }

  /// Compare two ScanSettings objects for equality
  bool _areScanSettingsEqual(ScanSettings a, ScanSettings b) {
    return a.followSymlinks == b.followSymlinks &&
        a.movieDepth == b.movieDepth &&
        a.tvDepth == b.tvDepth &&
        a.movieFilenamePattern == b.movieFilenamePattern &&
        a.movieDirectoryPattern == b.movieDirectoryPattern &&
        a.tvFilenamePattern == b.tvFilenamePattern &&
        a.tvDirectoryPattern == b.tvDirectoryPattern;
  }

  @override
  Widget build(BuildContext context) {
    // Use selector to watch only scanSettings - prevents rebuilds when other settings change
    // Only listen when we need to sync from server (not on every build)
    ref.listen<AsyncValue<ScanSettings>>(scanSettingsProvider, (
      previous,
      next,
    ) {
      // Only process data state changes
      if (!next.hasValue) return;

      final scanSettings = next.value!;

      // On initial load, always sync with server
      if (!_isInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _scanSettings = scanSettings;
              _isInitialized = true;
            });
          }
        });
        return;
      }

      // Smart sync: only update if server data is different from local state
      // Skip rebuild if both states match (memoized check)
      if (!_areScanSettingsEqual(_scanSettings, scanSettings)) {
        // Only sync if we're not currently saving any field (to avoid overwriting optimistic updates)
        if (!isAnyFieldSaving) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _scanSettings = scanSettings;
              });
            }
          });
        }
      }
    });

    return _buildContent(context);
  }

  /// Update a single setting immediately (for switches)
  /// Updates UI immediately and syncs to server without debouncing
  Future<void> _updateSetting<T>({
    required String fieldName,
    required T value,
    required ScanSettings Function(ScanSettings, T) updateFn,
  }) async {
    // Update local state optimistically
    final updatedSettings = updateFn(_scanSettings, value);
    _pendingUpdate = updatedSettings;

    // Use mixin's update (no debouncing since we have local copy)
    debouncedUpdateSettings(
      fieldName: fieldName,
      optimisticUpdate: () {
        _scanSettings = updatedSettings;
      },
      updateFn: () async {
        final updateSettings = ref.read(updateSettingsProvider);
        return await updateSettings(scanSettings: _pendingUpdate!);
      },
      skipInvalidationOnSuccess:
          true, // Don't invalidate - optimistic update is sufficient
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DSecondaryAppBar(
            title: AppLocalization.settingsScanSettingsTitle.tr(),
          ),
          SliverPadding(
            padding: AppConstants.padding(AppConstants.spacing16),
            sliver: SliverToBoxAdapter(
              child: DSidebarSpace(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // General Settings Section
                    SettingsSection(
                      title: AppLocalization.settingsScanGeneralSection.tr(),
                      group: SettingsGroup(
                        helperText: AppLocalization
                            .settingsScanGeneralGroupHelper
                            .tr(),
                        children: [
                          IsolatedSettingField.switch_(
                            fieldName: 'followSymlinks',
                            initialValue: _scanSettings.followSymlinks ?? true,
                            title: AppLocalization.settingsScanFollowSymlinks
                                .tr(),
                            isFirst: true,
                            enabled:
                                !isFieldSaving('followSymlinks') &&
                                !_isResetting,
                            onChanged: (value) {
                              _updateSetting<bool>(
                                fieldName: 'followSymlinks',
                                value: value,
                                updateFn: (settings, val) =>
                                    settings.copyWith(followSymlinks: val),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing16),
                    // Media Type Specific Settings Section
                    SettingsSection(
                      title: AppLocalization
                          .settingsScanMediaTypeSpecificSection
                          .tr(),
                      group: SettingsGroup(
                        helperText: AppLocalization
                            .settingsScanMediaTypeSpecificHelper
                            .tr(),
                        children: [
                          SettingsItem(
                            leadingIcon: getIconDataFromDIconName(
                              DIconName.film,
                            ),
                            title: AppLocalization
                                .settingsScanMovieSpecificSettings
                                .tr(),
                            trailingIcon: getIconDataFromDIconName(
                              DIconName.chevronRight,
                            ),
                            onTap: () {
                              context.pushNamed('movie-scan-settings');
                            },
                            isFirst: true,
                          ),
                          SettingsItem(
                            leadingIcon: getIconDataFromDIconName(DIconName.tv),
                            title: AppLocalization
                                .settingsScanTvShowSpecificSettings
                                .tr(),
                            trailingIcon: getIconDataFromDIconName(
                              DIconName.chevronRight,
                            ),
                            onTap: () {
                              context.pushNamed('tv-scan-settings');
                            },
                            isFirst: false,
                          ),
                        ],
                      ),
                    ),
                    AppConstants.spacingY(AppConstants.spacing16),
                    // Reset Settings Section
                    SettingsSection(
                      title: AppLocalization.settingsResetTitle.tr(),
                      group: SettingsGroup(
                        helperText: AppLocalization.settingsResetHelper.tr(),
                        children: [
                          SettingsItem(
                            leadingIcon: getIconDataFromDIconName(
                              DIconName.refreshCw,
                            ),
                            title: AppLocalization.settingsResetScanSettings
                                .tr(),
                            trailing: _isResetting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: DSpinner(),
                                  )
                                : null,
                            onTap: _isResetting || isAnyFieldSaving
                                ? null
                                : () => _resetScanSettings(context),
                            isFirst: true,
                          ),
                        ],
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

  /// Reset scan settings to defaults
  Future<void> _resetScanSettings(BuildContext context) async {
    if (_isResetting || isAnyFieldSaving) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.settingsResetConfirmTitle.tr()),
        content: Text(AppLocalization.settingsResetScanConfirmMessage.tr()),
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

    if (confirmed != true) return;

    setState(() {
      _isResetting = true;
    });

    setState(() {
      _isResetting = true;
    });

    try {
      final resetScanSettings = ref.read(resetScanSettingsProvider);
      final result = await resetScanSettings();

      result.fold(
        onSuccess: (_) {
          if (!mounted) return;
          // Reset changes settings to defaults, so we need to fetch new state
          throttledInvalidate(settingsProvider);
          setState(() {
            _isResetting = false;
          });
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalization.settingsResetScanSuccess.tr()),
                backgroundColor: AppConstants.successColor,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        onFailure: (failure) {
          if (!mounted) return;
          // On failure, invalidate to get correct server state
          throttledInvalidate(settingsProvider);
          setState(() {
            _isResetting = false;
          });
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: AppConstants.dangerColor,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isResetting = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalization.settingsResetScanError.tr()),
            backgroundColor: AppConstants.dangerColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
