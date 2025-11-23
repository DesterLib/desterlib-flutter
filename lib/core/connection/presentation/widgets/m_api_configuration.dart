// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/widgets/form_builder.dart';
import 'package:dester/core/widgets/m_base_modal.dart';


/// Modal for adding/editing API configurations
class ApiConfigurationModal extends StatefulWidget {
  final ApiConfiguration? initialConfig;
  final Function(String url, String label) onSave;

  const ApiConfigurationModal({
    super.key,
    this.initialConfig,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    ApiConfiguration? initialConfig,
    required Function(String url, String label) onSave,
  }) {
    BaseModal.show(
      context,
      title: initialConfig != null
          ? 'Edit API Configuration'
          : AppLocalization.settingsServersAddApi.tr(),
      content: ApiConfigurationModal(
        initialConfig: initialConfig,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ApiConfigurationModal> createState() => _ApiConfigurationModalState();
}

class _ApiConfigurationModalState extends State<ApiConfigurationModal> {
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
              key: 'label',
              labelText: AppLocalization.settingsServersApiLabel.tr(),
              hintText: AppLocalization.settingsServersEnterApiLabel.tr(),
              initialValue: widget.initialConfig?.label,
              prefixIcon: LucideIcons.tag,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Label is required';
                }
                return null;
              },
            ),
            FormFieldConfig(
              key: 'url',
              labelText: AppLocalization.settingsServersApiUrl.tr(),
              hintText: AppLocalization.settingsServersEnterApiUrl.tr(),
              initialValue: widget.initialConfig?.url,
              prefixIcon: LucideIcons.link,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'URL is required';
                }
                try {
                  final uri = Uri.parse(value.trim());
                  if (!uri.hasScheme ||
                      (!uri.hasAuthority && uri.host.isEmpty)) {
                    return 'Invalid URL format';
                  }
                } catch (e) {
                  return 'Invalid URL format';
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
    final url = values['url'] as String;
    final label = values['label'] as String;

    widget.onSave(url, label);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
