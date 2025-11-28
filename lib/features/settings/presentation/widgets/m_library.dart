// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_button.dart';
import 'package:dester/core/widgets/d_input.dart';
import 'package:dester/core/widgets/d_select.dart';
import 'package:dester/core/widgets/m_base_modal.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';

/// Modal for editing library details
class LibraryModal {
  static void show(
    BuildContext context, {
    Library? library,
    bool isEditMode = false,
    required Future<void> Function(
      String name,
      String? description,
      String? libraryPath,
      LibraryType? libraryType,
    )
    onSave,
  }) {
    final modal = _LibraryModalWidget(
      library: library,
      isEditMode: isEditMode,
      onSave: onSave,
    );

    BaseModal.show(
      context,
      title: isEditMode
          ? AppLocalization.settingsLibrariesEditLibrary.tr()
          : AppLocalization.settingsLibrariesAddLibrary.tr(),
      content: modal,
    );
  }
}

class _LibraryModalWidget extends StatefulWidget {
  final Library? library;
  final bool isEditMode;
  final Future<void> Function(
    String name,
    String? description,
    String? libraryPath,
    LibraryType? libraryType,
  )
  onSave;

  const _LibraryModalWidget({
    required this.library,
    required this.isEditMode,
    required this.onSave,
  });

  @override
  State<_LibraryModalWidget> createState() => _LibraryModalWidgetState();
}

class _LibraryModalWidgetState extends State<_LibraryModalWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DInput(
                name: 'name',
                initialValue: widget.library?.name,
                label: AppLocalization.settingsLibrariesLibraryName.tr(),
                hintText: AppLocalization.settingsLibrariesEnterLibraryName
                    .tr(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '${AppLocalization.settingsLibrariesLibraryName.tr()} is required';
                  }
                  return null;
                },
              ),
              AppConstants.spacingY(AppConstants.spacingMd),
              DInput(
                name: 'description',
                initialValue: widget.library?.description,
                label: AppLocalization.settingsLibrariesLibraryDescription.tr(),
                hintText: AppLocalization
                    .settingsLibrariesEnterLibraryDescription
                    .tr(),
                maxLines: 3,
              ),
              AppConstants.spacingY(AppConstants.spacingMd),
              DInput(
                name: 'path',
                initialValue: widget.library?.libraryPath,
                enabled: !widget.isEditMode,
                label: AppLocalization.settingsLibrariesLibraryPath.tr(),
                hintText: AppLocalization.settingsLibrariesEnterLibraryPath
                    .tr(),
                helperText: widget.isEditMode
                    ? 'Path cannot be changed after library creation'
                    : null,
              ),
              AppConstants.spacingY(AppConstants.spacingMd),
              DSelect<LibraryType>(
                name: 'type',
                initialValue: widget.library?.libraryType,
                enabled: !widget.isEditMode,
                label: AppLocalization.settingsLibrariesLibraryType.tr(),
                hintText: 'Select Library Type',
                helperText: widget.isEditMode
                    ? 'Type cannot be changed after library creation'
                    : null,
                items: LibraryType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        AppConstants.spacingY(AppConstants.spacingMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DButton(
              label: AppLocalization.settingsServersClose.tr(),
              variant: DButtonVariant.secondary,
              isDisabled: _isSaving,
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            AppConstants.spacingX(AppConstants.spacingSm),
            DButton(
              label: AppLocalization.settingsServersSave.tr(),
              variant: DButtonVariant.primary,
              isDisabled: _isSaving,
              onPressed: () => _handleSave(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final values = _formKey.currentState!.value;
    final name = (values['name'] as String?)?.trim() ?? '';
    final description = (values['description'] as String?)?.trim();
    final path = (values['path'] as String?)?.trim();
    final libraryPath = path?.isEmpty ?? true ? null : path;
    final libraryDescription = description?.isEmpty ?? true
        ? null
        : description;
    final selectedType = values['type'] as LibraryType?;

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    await widget.onSave(name, libraryDescription, libraryPath, selectedType);
  }
}
