// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/widgets/form_builder.dart';
import 'package:dester/core/widgets/m_base_modal.dart';

/// Modal for editing TMDB API key
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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormBuilder(
          key: _formKey,
          fields: [
            FormFieldConfig(
              key: 'apiKey',
              labelText: AppLocalization.settingsTmdbApiKey.tr(),
              hintText: AppLocalization.settingsTmdbEnterApiKey.tr(),
              initialValue: widget.initialApiKey,
              prefixIcon: LucideIcons.key300,
              obscureText: _obscureText,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              helperText: AppLocalization.settingsTmdbApiKeyHelper.tr(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? LucideIcons.eye300 : LucideIcons.eyeOff300,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalization.settingsTmdbApiKeyRequired.tr();
                }
                return null;
              },
            ),
          ],
          isSaving: _isSaving,
        ),
        FormActions(isSaving: _isSaving, onSave: () => _handleSave(context)),
      ],
    );
  }

  void _handleSave(BuildContext context) {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validateAndSubmit()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final values = formState.getFormValues();
    final apiKey = values['apiKey'] as String;

    widget.onSave(apiKey);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
