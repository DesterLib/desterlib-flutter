// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';

/// Standard form action buttons helper
/// Can be used with any form (flutter_form_builder, DForm, etc.)
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
              : (onClose ??
                    () => Navigator.of(context, rootNavigator: true).pop()),
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
