// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/widgets/form_builder.dart';
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
          fields: [
            FormFieldConfig(
              key: 'name',
              labelText: AppLocalization.settingsLibrariesLibraryName.tr(),
              hintText: AppLocalization.settingsLibrariesEnterLibraryName.tr(),
              initialValue: widget.library?.name,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '${AppLocalization.settingsLibrariesLibraryName.tr()} is required';
                }
                return null;
              },
            ),
            FormFieldConfig(
              key: 'description',
              labelText: AppLocalization.settingsLibrariesLibraryDescription
                  .tr(),
              hintText: AppLocalization.settingsLibrariesEnterLibraryDescription
                  .tr(),
              initialValue: widget.library?.description,
              maxLines: 3,
            ),
            FormFieldConfig(
              key: 'path',
              labelText: AppLocalization.settingsLibrariesLibraryPath.tr(),
              hintText: AppLocalization.settingsLibrariesEnterLibraryPath.tr(),
              initialValue: widget.library?.libraryPath,
              enabled: !widget.isEditMode,
              helperText: widget.isEditMode
                  ? 'Path cannot be changed after library creation'
                  : null,
            ),
          ],
          dropdownFields: [
            DropdownFieldConfig<LibraryType>(
              key: 'type',
              labelText: AppLocalization.settingsLibrariesLibraryType.tr(),
              initialValue: widget.library?.libraryType,
              enabled: !widget.isEditMode,
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
          isSaving: _isSaving,
        ),
        FormActions(isSaving: _isSaving, onSave: () => _handleSave(context)),
      ],
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validateAndSubmit()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final values = formState.getFormValues();
    final name = (values['name'] as String).trim();
    final description = (values['description'] as String?)?.trim();
    final path = (values['path'] as String?)?.trim();
    final libraryPath = path?.isEmpty ?? true ? null : path;
    final libraryDescription = description?.isEmpty ?? true
        ? null
        : description;
    final selectedType = values['type'] as LibraryType?;

    if (mounted) {
      Navigator.of(context).pop();
    }

    await widget.onSave(name, libraryDescription, libraryPath, selectedType);
  }
}
