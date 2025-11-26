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

// Features
import 'package:dester/features/settings/domain/entities/library.dart';

/// Library card widget for displaying library information
class LibraryCard extends ConsumerWidget {
  final Library library;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isScanning;
  final ScanProgressState? scanProgress;

  const LibraryCard({
    super.key,
    required this.library,
    required this.onEdit,
    required this.onDelete,
    this.isScanning = false,
    this.scanProgress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: AppConstants.paddingOnly(bottom: AppConstants.spacing12),
      elevation: 1,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: isScanning
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : DIcon(
                  icon: _getLibraryIcon(library.libraryType),
                  size: 24.0,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
        ),
        title: Text(library.name, style: AppTypography.titleMedium()),
        subtitle: _buildSubtitle(context),
        trailing: isScanning
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: DIcon(
                      icon: DIconName.edit,
                      size: AppConstants.iconSizeLg,
                    ),
                    tooltip: AppLocalization.settingsLibrariesEditLibrary.tr(),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const DIcon(
                      icon: DIconName.trash,
                      size: 24.0,
                      color: Colors.red,
                    ),
                    tooltip: AppLocalization.settingsLibrariesDeleteLibrary
                        .tr(),
                    onPressed: onDelete,
                  ),
                ],
              ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppConstants.spacingY(AppConstants.spacing4),
        if (scanProgress != null) ...[
          // Show scan progress
          Text(
            scanProgress!.message,
            style: AppTypography.bodySmall(
              color: Theme.of(context).colorScheme.primary,
            ).copyWith(fontWeight: AppTypography.weightMedium),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppConstants.spacingY(AppConstants.spacing4),
          LinearProgressIndicator(
            value: scanProgress!.progress / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          AppConstants.spacingY(AppConstants.spacing2),
          if (scanProgress!.total > 0)
            Text(
              '${scanProgress!.current} / ${scanProgress!.total}',
              style: AppTypography.bodySmall(color: Colors.grey[600]),
            ),
          AppConstants.spacingY(AppConstants.spacing2),
        ],
        if (library.description != null && library.description!.isNotEmpty)
          Text(
            library.description!,
            maxLines: isScanning ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall(color: Colors.grey[600]),
          ),
        if (library.description != null &&
            library.description!.isNotEmpty &&
            !isScanning)
          AppConstants.spacingY(AppConstants.spacing4),
        if (library.description != null &&
            library.description!.isNotEmpty &&
            isScanning)
          AppConstants.spacingY(AppConstants.spacing2),
        if (library.libraryType != null)
          Chip(
            label: Text(
              library.libraryType!.displayName,
              style: AppTypography.labelSmall(),
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        if (library.mediaCount != null)
          Padding(
            padding: AppConstants.paddingOnly(
              top: isScanning ? AppConstants.spacing2 : AppConstants.spacing4,
            ),
            child: Text(
              '${AppLocalization.settingsLibrariesMediaCount.tr()}: ${library.mediaCount}',
              style: AppTypography.bodySmall(color: Colors.grey[500]),
            ),
          ),
      ],
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
