import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/app/providers.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';

class AddLibraryModal {
  static Future<bool?> show(BuildContext context) {
    return showSettingsModal<bool>(
      context: context,
      title: 'Add Library',
      builder: (context) => const _AddLibraryModalContent(),
      useFullscreenOnMobile: true,
    );
  }
}

class _AddLibraryModalContent extends ConsumerStatefulWidget {
  const _AddLibraryModalContent();

  @override
  ConsumerState<_AddLibraryModalContent> createState() =>
      _AddLibraryModalContentState();
}

class _AddLibraryModalContentState
    extends ConsumerState<_AddLibraryModalContent> {
  final TextEditingController _pathController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? _mediaType;
  bool _rescan = false;
  bool _isScanning = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _pathController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleScan() async {
    if (_pathController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Path is required';
      });
      return;
    }

    if (_mediaType == null) {
      setState(() {
        _errorMessage = 'Media type is required';
      });
      return;
    }

    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final scanApi = ref.read(openapiClientProvider).getScanApi();

      final options = ApiV1ScanPathPostRequestOptionsBuilder();
      options.mediaType = _mediaType;
      options.rescan = _rescan;

      // Add library name if provided
      if (_nameController.text.trim().isNotEmpty) {
        options.libraryName = _nameController.text.trim();
      }

      final requestBuilder = ApiV1ScanPathPostRequestBuilder()
        ..path = _pathController.text.trim()
        ..options = options;

      final response = await scanApi.apiV1ScanPathPost(
        apiV1ScanPathPostRequest: requestBuilder.build(),
      );

      if (response.data?.success == true) {
        // Refresh libraries list
        ref.invalidate(actualLibrariesProvider);

        final totalSaved = response.data?.data?.totalSaved ?? 0;
        setState(() {
          _successMessage =
              'Library scan completed successfully! Added $totalSaved media items.';
        });

        // Close modal after a brief delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _errorMessage = response.data?.message ?? 'Scan failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to scan library: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info banner
        SettingsModalBanner(
          message:
              'Scan a directory on your server to automatically discover and add media files to your library.',
          type: SettingsModalBannerType.info,
        ),

        AppSpacing.gapVerticalLG,

        // Error banner
        if (_errorMessage != null)
          SettingsModalBanner(
            message: _errorMessage!,
            type: SettingsModalBannerType.error,
          ),

        // Success banner
        if (_successMessage != null)
          SettingsModalBanner(
            message: _successMessage!,
            type: SettingsModalBannerType.info,
            icon: Icons.check_circle_outline,
          ),

        // Library path
        SettingsModalTextField(
          controller: _pathController,
          label: 'Library Path',
          hintText: '/path/to/your/media/folder',
          enabled: !_isScanning,
        ),
        AppSpacing.gapVerticalLG,

        // Library name (optional)
        SettingsModalTextField(
          controller: _nameController,
          label: 'Library Name (Optional)',
          hintText: 'e.g., My Movies',
          enabled: !_isScanning,
        ),
        AppSpacing.gapVerticalLG,

        // Media type
        SettingsModalSection(
          label: 'Media Type',
          description: 'Required for proper metadata fetching',
          child: _MediaTypeDropdown(
            selectedType: _mediaType,
            enabled: !_isScanning,
            onChanged: (value) {
              setState(() {
                _mediaType = value;
              });
            },
          ),
        ),
        AppSpacing.gapVerticalLG,

        // Rescan option
        SettingsModalSection(
          label: 'Re-scan existing items',
          description:
              'Re-fetch metadata from TMDB even if it already exists in the database',
          child: Row(
            children: [
              Switch(
                value: _rescan,
                onChanged: _isScanning
                    ? null
                    : (value) {
                        setState(() {
                          _rescan = value;
                        });
                      },
                activeThumbColor: AppColors.primary,
              ),
              AppSpacing.gapHorizontalSM,
              Text(
                _rescan ? 'Enabled' : 'Disabled',
                style: AppTypography.bodyBase.copyWith(
                  color: _rescan ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapVerticalLG,

        // Actions
        SettingsModalActions(
          actions: [
            DButton(
              label: 'Cancel',
              variant: DButtonVariant.ghost,
              size: DButtonSize.md,
              onTap: _isScanning
                  ? null
                  : () => Navigator.of(context).pop(false),
            ),
            DButton(
              label: _isScanning ? 'Scanning...' : 'Scan & Add',
              variant: DButtonVariant.primary,
              size: DButtonSize.md,
              icon: _isScanning ? null : PlatformIcons.add,
              onTap: _isScanning ? null : _handleScan,
            ),
          ],
        ),
      ],
    );
  }
}

// Media type dropdown widget
class _MediaTypeDropdown extends StatelessWidget {
  final ApiV1ScanPathPostRequestOptionsMediaTypeEnum? selectedType;
  final bool enabled;
  final ValueChanged<ApiV1ScanPathPostRequestOptionsMediaTypeEnum?> onChanged;

  const _MediaTypeDropdown({
    required this.selectedType,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: enabled ? AppColors.surface : AppColors.backgroundElevated,
        borderRadius: AppRadius.radiusMD,
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ApiV1ScanPathPostRequestOptionsMediaTypeEnum?>(
          value: selectedType,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          style: AppTypography.bodyBase,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          items: [
            DropdownMenuItem<ApiV1ScanPathPostRequestOptionsMediaTypeEnum?>(
              value: null,
              child: Text(
                'Select media type',
                style: AppTypography.bodyBase.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            DropdownMenuItem<ApiV1ScanPathPostRequestOptionsMediaTypeEnum?>(
              value: ApiV1ScanPathPostRequestOptionsMediaTypeEnum.movie,
              child: Row(
                children: [
                  Icon(PlatformIcons.movie, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Text('Movies'),
                ],
              ),
            ),
            DropdownMenuItem<ApiV1ScanPathPostRequestOptionsMediaTypeEnum?>(
              value: ApiV1ScanPathPostRequestOptionsMediaTypeEnum.tv,
              child: Row(
                children: [
                  Icon(
                    PlatformIcons.videoLibrary,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  const Text('TV Shows'),
                ],
              ),
            ),
          ],
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}
