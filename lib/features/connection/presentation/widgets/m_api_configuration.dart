// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/features/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_input.dart';
import 'package:dester/core/widgets/form_actions.dart';
import 'package:dester/core/widgets/m_base_modal.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DInput(
                name: 'label',
                initialValue: widget.initialConfig?.label,
                label: AppLocalization.settingsServersApiLabel.tr(),
                hintText: AppLocalization.settingsServersEnterApiLabel.tr(),
                leadingIcon: DIconName.tag,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Label is required';
                  }
                  return null;
                },
              ),
              AppConstants.spacingY(AppConstants.spacingMd),
              DInput(
                name: 'url',
                initialValue: widget.initialConfig?.url,
                label: AppLocalization.settingsServersApiUrl.tr(),
                hintText: AppLocalization.settingsServersEnterApiUrl.tr(),
                leadingIcon: DIconName.link2,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL is required';
                  }
                  try {
                    final uri = Uri.parse(value.trim());
                    // Check if URL has a valid scheme (http, https, etc.)
                    if (!uri.hasScheme) {
                      return 'Invalid URL format: missing scheme (http:// or https://)';
                    }
                    // Check if URL has a valid host or authority
                    if (uri.host.isEmpty && !uri.hasAuthority) {
                      return 'Invalid URL format: missing host';
                    }
                  } catch (e) {
                    return 'Invalid URL format';
                  }
                  return null;
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
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final values = _formKey.currentState!.value;
    final url = (values['url'] as String?)?.trim() ?? '';
    final label = (values['label'] as String?)?.trim() ?? '';

    widget.onSave(url, label);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
