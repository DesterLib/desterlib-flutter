// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/m_base_modal.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';

/// Dialog for confirming library deletion
class DeleteLibraryDialog {
  static Future<bool?> show(
    BuildContext context, {
    required Library library,
  }) async {
    return await BaseModal.show<bool>(
      context,
      title: AppLocalization.settingsLibrariesDeleteLibrary.tr(),
      content: Text(
        '${AppLocalization.settingsLibrariesConfirmDeleteLibrary.tr()}\n\n"${library.name}"',
      ),
      actions: Builder(
        builder: (modalContext) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () =>
                  Navigator.of(modalContext, rootNavigator: true).pop(false),
              child: Text(AppLocalization.settingsServersClose.tr()),
            ),
            AppConstants.spacingX(AppConstants.spacingSm),
            TextButton(
              onPressed: () =>
                  Navigator.of(modalContext, rootNavigator: true).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(AppLocalization.settingsServersDelete.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
