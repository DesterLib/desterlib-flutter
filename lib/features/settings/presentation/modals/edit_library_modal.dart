import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/segmented_control.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';

class EditLibraryModal {
  static Future<bool?> show(BuildContext context, {required String libraryId}) {
    // Use root navigator context to avoid issues with nested navigators
    // This ensures the modal properly overlays the entire screen
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showSettingsModal<bool>(
      context: rootContext,
      title: 'Edit Library',
      builder: (context) => _EditLibraryModalContent(libraryId: libraryId),
      useFullscreenOnMobile: true,
    );
  }
}

class _EditLibraryModalContent extends ConsumerStatefulWidget {
  final String libraryId;

  const _EditLibraryModalContent({required this.libraryId});

  @override
  ConsumerState<_EditLibraryModalContent> createState() =>
      _EditLibraryModalContentState();
}

class _EditLibraryModalContentState
    extends ConsumerState<_EditLibraryModalContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();
  ModelLibraryLibraryTypeEnum? _selectedType;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    try {
      final libraries = await ref.read(actualLibrariesProvider.future);
      final library = libraries.firstWhere(
        (lib) => lib.id == widget.libraryId,
        orElse: () => throw Exception('Library not found'),
      );

      if (mounted) {
        setState(() {
          _nameController.text = library.name;
          _descriptionController.text = library.description ?? '';
          _pathController.text = library.libraryPath ?? '';
          _selectedType = library.libraryType;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load library: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Library name is required';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      ApiV1LibraryPutRequestLibraryTypeEnum? apiLibraryType;
      if (_selectedType != null) {
        apiLibraryType = _convertToApiLibraryType(_selectedType!);
      }

      final putRequest = ApiV1LibraryPutRequestBuilder()
        ..id = widget.libraryId
        ..name = _nameController.text.trim()
        ..description = _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim()
        ..libraryPath = _pathController.text.trim().isEmpty
            ? null
            : _pathController.text.trim()
        ..libraryType = apiLibraryType;

      await ref
          .read(libraryManagementProvider.notifier)
          .updateLibrary(putRequest.build());

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update library: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Error banner
        if (_errorMessage != null) ...[
          SettingsModalBanner(
            message: _errorMessage!,
            type: SettingsModalBannerType.error,
          ),
          AppSpacing.gapVerticalLG,
        ],

        // Library name
        SettingsModalTextField(
          controller: _nameController,
          label: 'Name',
          hintText: 'e.g., My Movies',
          enabled: !_isSaving,
        ),
        AppSpacing.gapVerticalLG,

        // Library type
        SettingsModalSection(
          label: 'Type',
          description: 'Currently supports Movies and TV Shows',
          child: DSegmentedControl<ModelLibraryLibraryTypeEnum>(
            value: _selectedType,
            enabled: !_isSaving,
            options: [
              SegmentedOption(
                value: ModelLibraryLibraryTypeEnum.MOVIE,
                label: 'Movies',
                icon: PlatformIcons.movie,
              ),
              SegmentedOption(
                value: ModelLibraryLibraryTypeEnum.TV_SHOW,
                label: 'TV Shows',
                icon: PlatformIcons.videoLibrary,
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value;
              });
            },
          ),
        ),
        AppSpacing.gapVerticalLG,

        // Library path
        SettingsModalTextField(
          controller: _pathController,
          label: 'Path (Optional)',
          hintText: '/path/to/your/media/folder',
          enabled: !_isSaving,
        ),
        AppSpacing.gapVerticalLG,

        // Description
        SettingsModalTextField(
          controller: _descriptionController,
          label: 'Description (Optional)',
          hintText: 'Enter a description for this library',
          maxLines: 2,
          enabled: !_isSaving,
        ),
        AppSpacing.gapVerticalLG,

        // Actions
        SettingsModalActions(
          actions: [
            DButton(
              label: 'Cancel',
              variant: DButtonVariant.ghost,
              size: DButtonSize.md,
              onTap: _isSaving ? null : () => Navigator.of(context).pop(false),
            ),
            DButton(
              label: _isSaving ? 'Saving...' : 'Save Changes',
              variant: DButtonVariant.primary,
              size: DButtonSize.md,
              onTap: _isSaving ? null : _handleSave,
            ),
          ],
        ),
      ],
    );
  }

  ApiV1LibraryPutRequestLibraryTypeEnum _convertToApiLibraryType(
    ModelLibraryLibraryTypeEnum type,
  ) {
    switch (type) {
      case ModelLibraryLibraryTypeEnum.MOVIE:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MOVIE;
      case ModelLibraryLibraryTypeEnum.TV_SHOW:
        return ApiV1LibraryPutRequestLibraryTypeEnum.TV_SHOW;
      case ModelLibraryLibraryTypeEnum.MUSIC:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MUSIC;
      case ModelLibraryLibraryTypeEnum.COMIC:
        return ApiV1LibraryPutRequestLibraryTypeEnum.COMIC;
      default:
        return ApiV1LibraryPutRequestLibraryTypeEnum.MOVIE;
    }
  }
}
