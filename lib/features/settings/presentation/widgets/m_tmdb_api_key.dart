// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_button.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_input.dart';
import 'package:dester/core/widgets/m_base_modal.dart';

/// Modal for editing TMDB API key
/// Note: This is the default metadata provider. The API uses a plugin system
/// that supports multiple providers, but currently TMDB is the only one available.
class TmdbApiKeyModal extends StatefulWidget {
  final String? initialApiKey;
  final Function(String apiKey) onSave;

  const TmdbApiKeyModal({super.key, this.initialApiKey, required this.onSave});

  static void show(
    BuildContext context, {
    String? initialApiKey,
    required Function(String apiKey) onSave,
  }) {
    BaseModal.show(
      context,
      title: AppLocalization.settingsTmdbApiKey.tr(),
      content: TmdbApiKeyModal(initialApiKey: initialApiKey, onSave: onSave),
    );
  }

  @override
  State<TmdbApiKeyModal> createState() => _TmdbApiKeyModalState();
}

class _TmdbApiKeyModalState extends State<TmdbApiKeyModal> {
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
                name: 'apiKey',
                initialValue: widget.initialApiKey,
                label: AppLocalization.settingsTmdbApiKey.tr(),
                hintText: AppLocalization.settingsTmdbEnterApiKey.tr(),
                helperText: AppLocalization.settingsTmdbApiKeyHelper.tr(),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalization.settingsTmdbApiKeyRequired.tr();
                  }
                  return null;
                },
                onSubmitted: (_) => _handleSave(context),
              ),
            ],
          ),
        ),
        AppConstants.spacingY(AppConstants.spacingLg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DButton(
              label: AppLocalization.settingsServersClose.tr(),
              variant: DButtonVariant.secondary,
              size: DButtonSize.sm,
              isDisabled: _isSaving,
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            AppConstants.spacingX(AppConstants.spacingSm),
            DButton(
              label: AppLocalization.settingsServersSave.tr(),
              variant: DButtonVariant.primary,
              size: DButtonSize.sm,
              leadingIcon: _isSaving ? null : DIconName.check,
              isDisabled: _isSaving,
              onPressed: () => _handleSave(context),
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  void _handleSave(BuildContext context) {
    // saveAndValidate() both validates and saves the form values
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final values = _formKey.currentState!.value;
    final apiKey = values['apiKey'] as String;

    widget.onSave(apiKey);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
