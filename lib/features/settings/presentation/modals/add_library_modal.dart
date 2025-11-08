import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/modals/configurable_modal.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/shared/utils/error_parser.dart';
import 'package:dester/app/providers.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';
import 'package:dester/features/settings/presentation/widgets/library_type_selector.dart';

class AddLibraryModal {
  static Future<bool?> show(BuildContext context, WidgetRef ref) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    return showConfigurableModal<bool>(
      context: rootContext,
      config: _createConfig(ref),
    );
  }

  static ModalConfig _createConfig(WidgetRef ref) {
    return ModalConfig(
      title: 'Add Library',
      useFullscreenOnMobile: true,
      banners: const [
        ModalBannerConfig(
          message:
              'Add a new library by specifying the path to your media folder. The system will scan and fetch metadata automatically.',
          type: SettingsModalBannerType.info,
        ),
      ],
      asyncInit: () async {
        return {
          'mediaType': ApiV1ScanPathPostRequestOptionsMediaTypeEnum.movie,
        };
      },
      fields: [
        ModalFieldConfig(
          key: 'name',
          label: 'Name (Optional)',
          hintText: 'e.g., My Movies',
        ),
        ModalFieldConfig(
          key: 'mediaType',
          label: 'Type',
          description:
              'Currently supports Movies and TV Shows. Music and Comics support coming soon.',
          customBuilder: (context, value, onChanged, state) {
            final currentType =
                state['mediaType']
                    as ApiV1ScanPathPostRequestOptionsMediaTypeEnum?;

            return LibraryTypeSelector.forAddLibrary(
              currentType: currentType,
              onChanged: (newValue) {
                state['mediaType'] = newValue;
                onChanged(newValue?.name);
              },
            );
          },
        ),
        ModalFieldConfig(
          key: 'path',
          label: 'Path',
          hintText: '/path/to/your/media/folder',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Path is required';
            }
            return null;
          },
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
          label: 'Scan & Add',
          icon: PlatformIcons.add,
          variant: DButtonVariant.primary,
          size: DButtonSize.sm,
          onTap: (values, state, context) async {
            final mediaType =
                state['mediaType']
                    as ApiV1ScanPathPostRequestOptionsMediaTypeEnum?;
            if (mediaType == null) {
              throw Exception('Media type is required');
            }

            final scanApi = ref.read(openapiClientProvider).getScanApi();

            final options = ApiV1ScanPathPostRequestOptionsBuilder();
            options.mediaType = mediaType;
            options.rescan = false;

            if (values['name']?.trim().isNotEmpty == true) {
              options.libraryName = values['name']!.trim();
            }

            final requestBuilder = ApiV1ScanPathPostRequestBuilder()
              ..path = values['path']!.trim()
              ..options = options;

            try {
              // Trigger the scan request
              await scanApi.apiV1ScanPathPost(
                apiV1ScanPathPostRequest: requestBuilder.build(),
              );

              // Close modal immediately - scan continues in background
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }

              // Refresh libraries to show the scanning state via WebSocket
              ref.read(refreshLibrariesProvider)();
            } catch (e) {
              // Use ErrorParser to extract meaningful error message
              final errorMessage = ErrorParser.parseScanError(e);
              throw Exception(errorMessage);
            }
          },
        ),
      ],
    );
  }
}
