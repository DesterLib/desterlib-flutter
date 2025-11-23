// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';


/// Field configuration for form builder
class FormFieldConfig {
  final String key;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? initialValue;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  const FormFieldConfig({
    required this.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });
}

/// Dropdown field configuration
class DropdownFieldConfig<T> {
  final String key;
  final String? labelText;
  final String? helperText;
  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final bool enabled;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;

  const DropdownFieldConfig({
    required this.key,
    this.labelText,
    this.helperText,
    this.initialValue,
    required this.items,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });
}

/// Form builder widget that simplifies form creation
class FormBuilder extends StatefulWidget {
  /// Form fields configuration
  final List<FormFieldConfig> fields;

  /// Dropdown fields configuration
  final List<DropdownFieldConfig>? dropdownFields;

  /// Spacing between fields (default: AppConstants.spacingMd)
  final double? fieldSpacing;

  /// Whether form is in saving state
  final bool isSaving;

  /// Callback when form is submitted
  final void Function(Map<String, dynamic> values)? onSubmit;

  /// Custom action buttons (if null, default save/close buttons are shown)
  final Widget? actions;

  const FormBuilder({
    super.key,
    required this.fields,
    this.dropdownFields,
    this.fieldSpacing,
    this.isSaving = false,
    this.onSubmit,
    this.actions,
  });

  @override
  State<FormBuilder> createState() => FormBuilderState();
}

/// Form builder state that can be accessed via GlobalKey
class FormBuilderState extends State<FormBuilder> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, ValueNotifier> _dropdownNotifiers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes for text fields
    for (final field in widget.fields) {
      _controllers[field.key] = TextEditingController(text: field.initialValue);
      _focusNodes[field.key] = FocusNode();
    }
    // Initialize notifiers for dropdown fields
    if (widget.dropdownFields != null) {
      for (final field in widget.dropdownFields!) {
        _dropdownNotifiers[field.key] = ValueNotifier(field.initialValue);
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    // Dispose focus nodes
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    // Dispose dropdown notifiers
    for (final notifier in _dropdownNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  /// Get current form values
  Map<String, dynamic> getFormValues() {
    final values = <String, dynamic>{};
    // Get text field values
    for (final entry in _controllers.entries) {
      values[entry.key] = entry.value.text.trim();
    }
    // Get dropdown values
    for (final entry in _dropdownNotifiers.entries) {
      values[entry.key] = entry.value.value;
    }
    return values;
  }

  /// Validate and submit form
  bool validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      if (widget.onSubmit != null) {
        widget.onSubmit!(getFormValues());
      }
      return true;
    }
    return false;
  }

  /// Get form key for external validation
  GlobalKey<FormState> get formKey => _formKey;

  /// Build dropdown field with proper typing
  Widget _buildDropdownField<T>(
    DropdownFieldConfig<T> field,
    ValueNotifier notifier,
    double spacing,
  ) {
    return ValueListenableBuilder<T?>(
      valueListenable: notifier as ValueNotifier<T?>,
      builder: (context, value, _) {
        return DropdownButtonFormField<T>(
          key: ValueKey(field.key),
          value: value,
          decoration: InputDecoration(
            labelText: field.labelText,
            helperText: field.helperText,
            border: const OutlineInputBorder(),
          ),
          items: field.items,
          validator: field.validator,
          onChanged: (field.enabled && !widget.isSaving)
              ? (newValue) {
                  notifier.value = newValue;
                  if (field.onChanged != null) {
                    field.onChanged!(newValue);
                  }
                }
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = widget.fieldSpacing ?? AppConstants.spacingMd;
    final fieldWidgets = <Widget>[];

    // Build text fields
    for (int i = 0; i < widget.fields.length; i++) {
      final field = widget.fields[i];
      final controller = _controllers[field.key]!;
      final focusNode = _focusNodes[field.key]!;
      final isLastField =
          i == widget.fields.length - 1 &&
          (widget.dropdownFields == null || widget.dropdownFields!.isEmpty);

      fieldWidgets.add(
        TextFormField(
          key: ValueKey(field.key),
          controller: controller,
          focusNode: focusNode,
          enabled: field.enabled && !widget.isSaving,
          obscureText: field.obscureText,
          maxLines: field.maxLines ?? 1,
          keyboardType: field.keyboardType,
          textInputAction:
              field.textInputAction ??
              (isLastField ? TextInputAction.done : TextInputAction.next),
          decoration: InputDecoration(
            labelText: field.labelText,
            hintText: field.hintText,
            helperText: field.helperText,
            border: const OutlineInputBorder(),
            prefixIcon: field.prefixIcon != null
                ? Icon(field.prefixIcon)
                : null,
            suffixIcon: field.suffixIcon,
          ),
          validator: field.validator,
          onChanged: field.onChanged,
          onFieldSubmitted:
              field.onFieldSubmitted ??
              (isLastField
                  ? (_) {
                      focusNode.unfocus();
                      if (widget.onSubmit != null) {
                        validateAndSubmit();
                      }
                    }
                  : (_) {
                      // Move to next field
                      if (i < widget.fields.length - 1) {
                        _focusNodes[widget.fields[i + 1].key]!.requestFocus();
                      } else if (widget.dropdownFields != null &&
                          widget.dropdownFields!.isNotEmpty) {
                        // Focus first dropdown if available
                        // Dropdowns don't have focus nodes, so just unfocus
                        focusNode.unfocus();
                      }
                    }),
        ),
      );

      // Add spacing if not last field
      if (!isLastField || widget.dropdownFields != null) {
        fieldWidgets.add(AppConstants.spacingY(spacing));
      }
    }

    // Build dropdown fields
    if (widget.dropdownFields != null) {
      for (int i = 0; i < widget.dropdownFields!.length; i++) {
        final field = widget.dropdownFields![i];
        final notifier = _dropdownNotifiers[field.key]!;

        fieldWidgets.add(_buildDropdownField(field, notifier, spacing));

        // Add spacing if not last dropdown
        if (i < widget.dropdownFields!.length - 1) {
          fieldWidgets.add(AppConstants.spacingY(spacing));
        }
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...fieldWidgets,
          if (widget.actions != null) ...[
            AppConstants.spacingY(AppConstants.spacingLg),
            widget.actions!,
          ],
        ],
      ),
    );
  }
}

/// Standard form action buttons
class FormActions extends StatelessWidget {
  final bool isSaving;
  final VoidCallback? onClose;
  final VoidCallback? onSave;
  final String? closeLabel;
  final String? saveLabel;

  const FormActions({
    super.key,
    this.isSaving = false,
    this.onClose,
    this.onSave,
    this.closeLabel,
    this.saveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isSaving
              ? null
              : (onClose ?? () => Navigator.of(context).pop()),
          child: Text(closeLabel ?? AppLocalization.settingsServersClose.tr()),
        ),
        AppConstants.spacingX(AppConstants.spacingSm),
        ElevatedButton.icon(
          onPressed: isSaving ? null : onSave,
          icon: isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(LucideIcons.save),
          label: Text(saveLabel ?? AppLocalization.settingsServersSave.tr()),
        ),
      ],
    );
  }
}
