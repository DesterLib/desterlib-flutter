// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_button.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_spinner.dart';

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
        DButton(
          label: closeLabel ?? AppLocalization.settingsServersClose.tr(),
          variant: DButtonVariant.secondary,
          size: DButtonSize.sm,
          isDisabled: isSaving,
          onPressed:
              onClose ?? () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        AppConstants.spacingX(AppConstants.spacingSm),
        DButton(
          label: saveLabel ?? AppLocalization.settingsServersSave.tr(),
          variant: DButtonVariant.primary,
          size: DButtonSize.sm,
          leadingIcon: isSaving ? null : DIconName.check,
          isDisabled: isSaving,
          onPressed: onSave,
          child: isSaving
              ? const SizedBox(width: 16, height: 16, child: DSpinner())
              : null,
        ),
      ],
    );
  }
}
