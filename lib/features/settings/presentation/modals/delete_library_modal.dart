import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:dester/shared/widgets/modals/configurable_modal.dart';
import 'package:dester/shared/widgets/modals/settings_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/features/library/data/providers/library_provider.dart';
import 'package:dester/features/library/utils/library_helpers.dart';

class DeleteLibraryModal {
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
      title: 'Delete Library',
      banners: const [
        ModalBannerConfig(
          message:
              'Warning: This action cannot be undone. Media files on disk will not be deleted.',
          type: SettingsModalBannerType.warning,
          icon: Icons.warning_amber_outlined,
        ),
      ],
      fields: const [],
      asyncInit: () async {
        final libraries = await ref.read(actualLibrariesProvider.future);
        final library = libraries.firstWhere(
          (lib) => lib.id == libraryId,
          orElse: () => throw Exception('Library not found'),
        );
        return {'library': library};
      },
      customSections: [
        ModalSectionConfig(
          position: 0,
          builder: (context, state, updateState) {
            final library = state['library'] as ModelLibrary?;
            if (library == null) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LibraryInfoCard(library: library),
                AppSpacing.gapVerticalLG,
                Text(
                  'Are you sure you want to delete this library?',
                  style: AppTypography.h4,
                ),
                AppSpacing.gapVerticalMD,
                Text(
                  'This will also delete all media entries that belong exclusively to this library.',
                  style: AppTypography.bodyBase.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.gapVerticalLG,
              ],
            );
          },
        ),
      ],
      actions: [
        ModalActionConfig(
          label: 'Delete Library',
          variant: DButtonVariant.danger,
          size: DButtonSize.sm,
          onTap: (values, state, context) async {
            await ref
                .read(libraryManagementProvider.notifier)
                .deleteLibrary(libraryId);

            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
    );
  }
}

class _LibraryInfoCard extends StatelessWidget {
  final ModelLibrary library;

  const _LibraryInfoCard({required this.library});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMD,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: AppRadius.radiusSM,
            ),
            child: Icon(
              LibraryHelpers.getLibraryIcon(library.libraryType),
              color: AppColors.primary,
              size: 24,
            ),
          ),
          AppSpacing.gapHorizontalMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(library.name, style: AppTypography.h4),
                AppSpacing.gapVerticalXS,
                Text(
                  LibraryHelpers.getLibraryTypeDisplayName(library.libraryType),
                  style: AppTypography.bodySmall,
                ),
                if (library.libraryPath != null) ...[
                  AppSpacing.gapVerticalXS,
                  Row(
                    children: [
                      Icon(
                        PlatformIcons.folder,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.gapHorizontalXS,
                      Expanded(
                        child: Text(
                          library.libraryPath!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
