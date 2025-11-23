// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
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
      shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: isScanning
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  _getLibraryIcon(library.libraryType),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
        ),
        title: Text(
          library.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _buildSubtitle(context),
        trailing: isScanning
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.pencil300),
                    tooltip: AppLocalization.settingsLibrariesEditLibrary.tr(),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.trash2300),
                    tooltip: AppLocalization.settingsLibrariesDeleteLibrary
                        .tr(),
                    color: Colors.red,
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
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
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
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          AppConstants.spacingY(AppConstants.spacing2),
        ],
        if (library.description != null && library.description!.isNotEmpty)
          Text(
            library.description!,
            maxLines: isScanning ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
              style: const TextStyle(fontSize: 10),
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
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ),
      ],
    );
  }

  IconData _getLibraryIcon(LibraryType? type) {
    if (type == null) return LucideIcons.library300;
    switch (type) {
      case LibraryType.movie:
        return LucideIcons.film300;
      case LibraryType.tvShow:
        return LucideIcons.tv300;
      case LibraryType.music:
        return LucideIcons.music300;
      case LibraryType.comic:
        return LucideIcons.bookOpen300;
    }
  }
}
