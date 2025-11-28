// External packages
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Core
import 'package:dester/core/widgets/d_switch.dart';

// Features
import 'package:dester/features/settings/presentation/widgets/settings_item.dart';

/// Wrapper widget that creates an isolated form field for a single setting
/// Each setting item works independently without affecting others
class IsolatedSettingField<T> extends StatefulWidget {
  final String fieldName;
  final T initialValue;
  final String title;
  final bool isFirst;
  final bool enabled;
  final ValueChanged<T> onChanged;
  final Widget Function(BuildContext context, FormFieldState<T> field) builder;

  const IsolatedSettingField({
    super.key,
    required this.fieldName,
    required this.initialValue,
    required this.title,
    this.isFirst = false,
    this.enabled = true,
    required this.onChanged,
    required this.builder,
  });

  /// Factory constructor for boolean switch settings
  static IsolatedSettingField<bool> switch_({
    required String fieldName,
    required bool initialValue,
    required String title,
    bool isFirst = false,
    bool enabled = true,
    required ValueChanged<bool> onChanged,
  }) {
    return IsolatedSettingField<bool>(
      fieldName: fieldName,
      initialValue: initialValue,
      title: title,
      isFirst: isFirst,
      enabled: enabled,
      onChanged: onChanged,
      builder: (context, field) => SettingsItem(
        title: title,
        trailing: DSwitch(
          value: field.value ?? initialValue,
          enabled: enabled,
          onChanged: (value) {
            field.didChange(value);
            onChanged(value);
          },
        ),
        isFirst: isFirst,
      ),
    );
  }

  @override
  State<IsolatedSettingField<T>> createState() =>
      _IsolatedSettingFieldState<T>();
}

class _IsolatedSettingFieldState<T> extends State<IsolatedSettingField<T>> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void didUpdateWidget(IsolatedSettingField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update form field value when initialValue changes
    if (oldWidget.initialValue != widget.initialValue) {
      _formKey.currentState?.fields[widget.fieldName]?.didChange(
        widget.initialValue,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: FormBuilderField<T>(
        name: widget.fieldName,
        initialValue: widget.initialValue,
        builder: (field) => widget.builder(context, field),
      ),
    );
  }
}
