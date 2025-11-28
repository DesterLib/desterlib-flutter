// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/core/widgets/d_icon.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/websocket/websocket_provider.dart';
import 'package:dester/core/widgets/d_icon_button.dart';
import 'package:dester/core/widgets/d_popup_menu.dart';

// Features
import 'package:dester/features/settings/domain/entities/library.dart';

/// Library card widget for displaying library information
class LibraryCard extends ConsumerWidget {
  final Library library;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isScanning;
  final ScanProgressState? scanProgress;
  final bool inGroup;
  final bool isFirst;

  const LibraryCard({
    super.key,
    required this.library,
    required this.onEdit,
    required this.onDelete,
    this.isScanning = false,
    this.scanProgress,
    this.inGroup = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build trailing menu button with ellipsis using DIconButton sm size
    final trailingWidget = isScanning
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : DPopupMenu<String>(
            icon: DIconName.ellipsis,
            size: DIconButtonSize.sm,
            variant: DIconButtonVariant.secondary,
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            items: [
              DPopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      getIconDataFromDIconName(
                        DIconName.edit,
                        strokeWidth: 2.0,
                      ),
                      size: 16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    Text(AppLocalization.settingsLibrariesEditLibrary.tr()),
                  ],
                ),
              ),
              DPopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      getIconDataFromDIconName(
                        DIconName.trash,
                        strokeWidth: 2.0,
                      ),
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    Text(
                      AppLocalization.settingsLibrariesDeleteLibrary.tr(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          );

    // Build leading icon matching SettingsItem exactly (size 24, simple Icon)
    final leadingIcon = isScanning
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).iconTheme.color?.withValues(alpha: 0.6) ??
                    Colors.grey,
              ),
            ),
          )
        : Icon(
            getIconDataFromDIconName(
              _getLibraryIcon(library.libraryType),
              strokeWidth: 2.0,
            ),
            size: 24,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
          );

    // Build content matching SettingsItem structure exactly
    final content = Container(
      padding: AppConstants.paddingX(AppConstants.spacing16),
      child: SizedBox(
        child: Row(
          children: [
            leadingIcon,
            SizedBox(width: AppConstants.spacing8),
            Expanded(
              child: Container(
                height: 48,
                alignment: Alignment.centerLeft,
                decoration: isFirst
                    ? null
                    : BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        library.name,
                        style: AppTypography.titleSmall(),
                      ),
                    ),
                    trailingWidget,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (inGroup) {
      // When in a group, return content directly - SettingsGroup provides the container
      return content;
    }

    // When standalone, use Card wrapper
    return Card(
      margin: AppConstants.paddingOnly(bottom: AppConstants.spacing12),
      elevation: 1,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: content,
    );
  }

  DIconName _getLibraryIcon(LibraryType? type) {
    if (type == null) return DIconName.library;
    switch (type) {
      case LibraryType.movie:
        return DIconName.film;
      case LibraryType.tvShow:
        return DIconName.tv;
      case LibraryType.music:
        return DIconName.music;
      case LibraryType.comic:
        return DIconName.bookOpen;
    }
  }
}
