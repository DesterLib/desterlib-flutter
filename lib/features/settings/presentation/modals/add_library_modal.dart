import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/segmented_control.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/app/providers.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';

class AddLibraryModal {
  static Future<bool?> show(BuildContext context) {
    // Use root navigator context to avoid issues with nested navigators
    // This ensures the modal properly overlays the entire screen
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showSettingsModal<bool>(
      context: rootContext,
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? _mediaType;
  bool _rescan = false;
  bool _isScanning = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _pathController.dispose();
    _descriptionController.dispose();
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

      // Add description if provided (for future use)
      // Note: Current API doesn't support description in scan endpoint

      final requestBuilder = ApiV1ScanPathPostRequestBuilder()
        ..path = _pathController.text.trim()
        ..options = options;

      // Start the scan (non-blocking) - it will continue in background via WebSocket
      scanApi
          .apiV1ScanPathPost(apiV1ScanPathPostRequest: requestBuilder.build())
          .then((response) {
            // Refresh libraries list when scan API call returns
            ref.invalidate(actualLibrariesProvider);
          })
          .catchError((e) {
            // Handle errors silently - WebSocket will report progress
            debugPrint('Scan API error: $e');
          });

      // Close modal immediately - progress will be shown via WebSocket
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to start scan: ${e.toString()}';
        _isScanning = false;
      });
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
              'Add a new library by specifying the path to your media folder. The system will scan and fetch metadata automatically.',
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

        // Library name
        SettingsModalTextField(
          controller: _nameController,
          label: 'Name (Optional)',
          hintText: 'e.g., My Movies',
          enabled: !_isScanning,
        ),
        AppSpacing.gapVerticalLG,

        // Library type
        SettingsModalSection(
          label: 'Type',
          description:
              'Currently supports Movies and TV Shows. Music and Comics support coming soon.',
          child:
              DSegmentedControl<ApiV1ScanPathPostRequestOptionsMediaTypeEnum>(
                value: _mediaType,
                enabled: !_isScanning,
                options: [
                  SegmentedOption(
                    value: ApiV1ScanPathPostRequestOptionsMediaTypeEnum.movie,
                    label: 'Movies',
                    icon: PlatformIcons.movie,
                  ),
                  SegmentedOption(
                    value: ApiV1ScanPathPostRequestOptionsMediaTypeEnum.tv,
                    label: 'TV Shows',
                    icon: PlatformIcons.videoLibrary,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _mediaType = value;
                  });
                },
              ),
        ),
        AppSpacing.gapVerticalLG,

        // Library path
        SettingsModalTextField(
          controller: _pathController,
          label: 'Path',
          hintText: '/path/to/your/media/folder',
          enabled: !_isScanning,
        ),
        AppSpacing.gapVerticalLG,

        // Description
        SettingsModalTextField(
          controller: _descriptionController,
          label: 'Description (Optional)',
          hintText: 'Enter a description for this library',
          maxLines: 2,
          enabled: !_isScanning,
        ),
        AppSpacing.gapVerticalLG,

        // Rescan option
        SettingsModalSection(
          label: 'Rescan Existing Media',
          description: 'Re-fetch metadata from TMDB even if it already exists',
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
