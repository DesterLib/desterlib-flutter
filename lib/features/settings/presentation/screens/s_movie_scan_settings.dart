// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_app_bar.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
// Features
import 'package:dester/features/settings/domain/entities/settings.dart';
import 'package:dester/features/settings/domain/entities/scan_settings.dart';
import 'package:dester/features/settings/presentation/mixins/settings_update_mixin.dart';
import 'package:dester/features/settings/presentation/widgets/settings_form_field.dart';
import 'package:dester/features/settings/domain/usecases/get_settings.dart';
import 'package:dester/features/settings/domain/usecases/update_settings.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_section.dart';
import 'package:dester/features/settings/presentation/widgets/settings_slider.dart';
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

/// Selector provider for scanSettings only - prevents unnecessary rebuilds
final scanSettingsProvider = FutureProvider<ScanSettings>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  return settings.scanSettings ?? ScanSettings.defaults;
});

/// Screen for managing movie-specific scan settings
class MovieScanSettingsScreen extends ConsumerStatefulWidget {
  const MovieScanSettingsScreen({super.key});

  @override
  ConsumerState<MovieScanSettingsScreen> createState() =>
      _MovieScanSettingsScreenState();
}

class _MovieScanSettingsScreenState
    extends ConsumerState<MovieScanSettingsScreen>
    with SettingsUpdateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  late ScanSettings _scanSettings;

  @override
  void initState() {
    super.initState();
    _scanSettings = ScanSettings.defaults;
  }

  @override
  Widget build(BuildContext context) {
    // Use selector to watch only scanSettings - prevents rebuilds when other settings change
    return ref
        .watch(scanSettingsProvider)
        .when(
          data: (scanSettings) {
            // Only update if different (prevents unnecessary setState)
            if (_scanSettings != scanSettings) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _scanSettings = scanSettings;
                  });
                }
              });
            }
            return _buildContent(context);
          },
          loading: () => _buildContent(context),
          error: (error, stack) => _buildContent(context),
        );
  }

  /// Update a single setting immediately (for sliders)
  /// Updates UI immediately and syncs to server without debouncing
  Future<void> _updateSetting<T>({
    required String fieldName,
    required T value,
    required ScanSettings Function(ScanSettings, T) updateFn,
  }) async {
    final updatedSettings = updateFn(_scanSettings, value);

    debouncedUpdateSettings(
      fieldName: fieldName,
      optimisticUpdate: () {
        _scanSettings = updatedSettings;
      },
      updateFn: () async {
        final updateSettings = ref.read(updateSettingsProvider);
        return await updateSettings(scanSettings: updatedSettings);
      },
      skipInvalidationOnSuccess: true,
      providerToInvalidate: settingsProvider,
    );
  }

  /// Update for text fields
  /// Updates UI immediately and syncs to server without debouncing
  void _debouncedUpdateSetting<T>({
    required String fieldName,
    required T value,
    required ScanSettings Function(ScanSettings, T) updateFn,
  }) {
    final updatedSettings = updateFn(_scanSettings, value);

    debouncedUpdateSettings(
      fieldName: fieldName,
      optimisticUpdate: () {
        _scanSettings = updatedSettings;
      },
      updateFn: () async {
        final updateSettings = ref.read(updateSettingsProvider);
        return await updateSettings(scanSettings: updatedSettings);
      },
      skipInvalidationOnSuccess: true,
      providerToInvalidate: settingsProvider,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DAppBar(
            title: AppLocalization.settingsScanMovieSpecificSettings.tr(),
            isCompact: true,
          ),
          SliverPadding(
            padding: AppConstants.padding(AppConstants.spacing16),
            sliver: SliverToBoxAdapter(
              child: DSidebarSpace(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Scan Depth Section
                      SettingsSection(
                        title: AppLocalization.settingsScanScanDepthSection
                            .tr(),
                        group: SettingsGroup(
                          helperText: AppLocalization
                              .settingsScanDepthGroupHelper
                              .tr(),
                          children: [
                            FormBuilderField<double>(
                              name: 'movieDepth',
                              initialValue:
                                  _scanSettings.movieDepth?.toDouble() ?? 0.0,
                              builder: (field) => SettingsSlider(
                                value: field.value ?? 0.0,
                                min: 0.0,
                                max: 2.0,
                                divisions: 2,
                                labelBuilder: (value) =>
                                    value.toInt().toString(),
                                enabled: !isAnyFieldSaving,
                                onChanged: (value) {
                                  field.didChange(value);
                                  _updateSetting<int>(
                                    fieldName: 'movieDepth',
                                    value: value.toInt(),
                                    updateFn: (settings, val) =>
                                        settings.copyWith(movieDepth: val),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppConstants.spacingY(AppConstants.spacing16),
                      // Directory Name Regex Pattern Section
                      SettingsSection(
                        title: AppLocalization
                            .settingsScanDirectoryNameRegexPatternSection
                            .tr(),
                        group: SettingsGroup(
                          helperText: AppLocalization
                              .settingsScanDirectoryPatternHelper
                              .tr(),
                          children: [
                            FormBuilderField<String>(
                              name: 'movieDirectoryPattern',
                              initialValue:
                                  _scanSettings.movieDirectoryPattern ?? '',
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  try {
                                    RegExp(value);
                                  } catch (e) {
                                    return AppLocalization
                                        .settingsScanRegexInvalid
                                        .tr();
                                  }
                                }
                                return null;
                              },
                              builder: (field) => SettingsFormField(
                                initialValue: field.value,
                                hintText: AppLocalization
                                    .settingsScanDirectoryPatternHint
                                    .tr(),
                                keyboardType: TextInputType.text,
                                enabled: !isAnyFieldSaving,
                                errorText: field.errorText,
                                onChanged: (value) {
                                  field.didChange(value);
                                  // Only update if valid (or empty)
                                  if (field.errorText == null ||
                                      value.isEmpty) {
                                    _debouncedUpdateSetting<String?>(
                                      fieldName: 'movieDirectoryPattern',
                                      value: value.isEmpty ? null : value,
                                      updateFn: (settings, val) =>
                                          settings.copyWith(
                                            mediaTypePatterns:
                                                MediaTypePatterns(
                                                  movie: MoviePatterns(
                                                    filenamePattern: settings
                                                        .movieFilenamePattern,
                                                    directoryPattern: val,
                                                  ),
                                                  tv: settings
                                                      .mediaTypePatterns
                                                      ?.tv,
                                                ),
                                          ),
                                    );
                                  }
                                },
                                isFirst: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppConstants.spacingY(AppConstants.spacing16),
                      // File Name Regex Pattern Section
                      SettingsSection(
                        title: AppLocalization
                            .settingsScanFileNameRegexPatternSection
                            .tr(),
                        group: SettingsGroup(
                          helperText: AppLocalization
                              .settingsScanFilenamePatternHelper
                              .tr(),
                          children: [
                            FormBuilderField<String>(
                              name: 'movieFilenamePattern',
                              initialValue:
                                  _scanSettings.movieFilenamePattern ?? '',
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  try {
                                    RegExp(value);
                                  } catch (e) {
                                    return AppLocalization
                                        .settingsScanRegexInvalid
                                        .tr();
                                  }
                                }
                                return null;
                              },
                              builder: (field) => SettingsFormField(
                                initialValue: field.value,
                                hintText: AppLocalization
                                    .settingsScanFilenamePatternHint
                                    .tr(),
                                keyboardType: TextInputType.text,
                                enabled: !isAnyFieldSaving,
                                errorText: field.errorText,
                                onChanged: (value) {
                                  field.didChange(value);
                                  // Only update if valid (or empty)
                                  if (field.errorText == null ||
                                      value.isEmpty) {
                                    _debouncedUpdateSetting<String?>(
                                      fieldName: 'movieFilenamePattern',
                                      value: value.isEmpty ? null : value,
                                      updateFn: (settings, val) =>
                                          settings.copyWith(
                                            mediaTypePatterns:
                                                MediaTypePatterns(
                                                  movie: MoviePatterns(
                                                    filenamePattern: val,
                                                    directoryPattern: settings
                                                        .movieDirectoryPattern,
                                                  ),
                                                  tv: settings
                                                      .mediaTypePatterns
                                                      ?.tv,
                                                ),
                                          ),
                                    );
                                  }
                                },
                                isFirst: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
