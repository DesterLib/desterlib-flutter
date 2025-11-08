import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/modals/configurable_modal.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';
import 'package:dester/features/library/utils/library_helpers.dart';
import 'package:dester/features/settings/presentation/widgets/library_type_selector.dart';

class EditLibraryModal {
  static Future<bool?> show(
    BuildContext context,
    WidgetRef ref, {
    required String libraryId,
  }) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showConfigurableModal<bool>(
      context: rootContext,
      config: _createConfig(ref, libraryId),
    );
  }

  static ModalConfig _createConfig(WidgetRef ref, String libraryId) {
    return ModalConfig(
      title: 'Edit Library',
      useFullscreenOnMobile: true,
      banners: const [],
      asyncInit: () async {
        final libraries = await ref.read(actualLibrariesProvider.future);
        final library = libraries.firstWhere(
          (lib) => lib.id == libraryId,
          orElse: () => throw Exception('Library not found'),
        );
        return {
          'name': library.name,
          'description': library.description ?? '',
          'libraryPath': library.libraryPath ?? '',
          'libraryType': library.libraryType,
        };
      },
      fields: [
        ModalFieldConfig(
          key: 'name',
          label: 'Name',
          hintText: 'e.g., My Movies',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Library name is required';
            }
            return null;
          },
        ),
        ModalFieldConfig(
          key: 'libraryType',
          label: 'Type',
          description: 'Currently supports Movies and TV Shows',
          customBuilder: (context, value, onChanged, state) {
            final currentType =
                state['libraryType'] as ModelLibraryLibraryTypeEnum?;

            return LibraryTypeSelector.forEditLibrary(
              currentType: currentType,
              onChanged: (newValue) {
                state['libraryType'] = newValue;
                onChanged(newValue?.name);
              },
            );
          },
        ),
        ModalFieldConfig(
          key: 'libraryPath',
          label: 'Path (Optional)',
          hintText: '/path/to/your/media/folder',
        ),
        ModalFieldConfig(
          key: 'description',
          label: 'Description (Optional)',
          hintText: 'Enter a description for this library',
          maxLines: 2,
        ),
      ],
      actions: [
        ModalActionConfig(
          label: 'Save Changes',
          variant: DButtonVariant.primary,
          size: DButtonSize.sm,
          onTap: (values, state, context) async {
            final putRequest = ApiV1LibraryPutRequestBuilder()
              ..id = libraryId
              ..name = values['name']?.trim()
              ..description = values['description']?.trim().isEmpty == true
                  ? null
                  : values['description']?.trim()
              ..libraryPath = values['libraryPath']?.trim().isEmpty == true
                  ? null
                  : values['libraryPath']?.trim()
              ..libraryType =
                  (state['libraryType'] as ModelLibraryLibraryTypeEnum?)
                      ?.toApiLibraryType();

            await ref
                .read(libraryManagementProvider.notifier)
                .updateLibrary(putRequest.build());

            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
    );
  }
}
