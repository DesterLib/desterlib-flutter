// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/widgets/form_actions.dart';
import 'package:dester/core/widgets/m_base_modal.dart';

// Features
import 'package:dester/features/settings/presentation/widgets/settings_form_field.dart';

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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Use flutter_form_builder - clean and composable!
        FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Use SettingsFormField wrapped in FormBuilderField
              // FormBuilderField handles state management, SettingsFormField handles UI
              FormBuilderField<String>(
                name: 'apiKey',
                initialValue: widget.initialApiKey,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalization.settingsTmdbApiKeyRequired.tr();
                  }
                  return null;
                },
                builder: (field) {
                  return SettingsFormField(
                    initialValue: field.value,
                    labelText: AppLocalization.settingsTmdbApiKey.tr(),
                    hintText: AppLocalization.settingsTmdbEnterApiKey.tr(),
                    helperText: AppLocalization.settingsTmdbApiKeyHelper.tr(),
                    leadingIcon: LucideIcons.key300,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? LucideIcons.eye300
                            : LucideIcons.eyeOff300,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    validator: (_) => field.errorText,
                    errorText: field.errorText,
                    onChanged: (value) {
                      field.didChange(value);
                    },
                    onFieldSubmitted: (_) => _handleSave(context),
                  );
                },
              ),
            ],
          ),
        ),
        FormActions(isSaving: _isSaving, onSave: () => _handleSave(context)),
      ],
    );
  }

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
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
