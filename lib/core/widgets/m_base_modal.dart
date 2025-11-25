// Dart
import 'dart:io';

// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

import '../../../../app/router/app_router.dart';

/// Base modal widget that adapts to platform
/// Shows as Dialog on desktop, DraggableScrollableSheet on mobile
class BaseModal extends StatelessWidget {
  /// Title displayed in the header
  final String title;

  /// Content widget to display in the modal
  final Widget content;

  /// Optional actions widget (typically buttons)
  /// If not provided, only the close button will be shown
  final Widget? actions;

  /// Callback when close button is pressed
  final VoidCallback? onClose;

  /// Whether to show the close button (default: true)
  final bool showCloseButton;

  /// Maximum width for desktop modal (default: AppConstants.modalMaxWidth)
  final double? maxWidth;

  /// Maximum height for desktop modal (default: AppConstants.modalMaxHeight)
  final double? maxHeight;

  /// Initial child size for mobile bottom sheet (default: 0.7)
  final double initialChildSize;

  /// Minimum child size for mobile bottom sheet (default: 0.3)
  final double minChildSize;

  /// Maximum child size for mobile bottom sheet (default: 0.9)
  final double maxChildSize;

  /// Whether the content should be scrollable on mobile (default: true)
  final bool isScrollable;

  const BaseModal({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.onClose,
    this.showCloseButton = true,
    this.maxWidth,
    this.maxHeight,
    this.initialChildSize = 0.7,
    this.minChildSize = 0.3,
    this.maxChildSize = 0.9,
    this.isScrollable = false,
  });

  /// Check if running on desktop platform
  static bool get isDesktop {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// Show the modal with platform adaptation
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    Widget? actions,
    VoidCallback? onClose,
    bool showCloseButton = true,
    double? maxWidth,
    double? maxHeight,
    double initialChildSize = 0.7,
    double minChildSize = 0.3,
    double maxChildSize = 0.9,
    bool isScrollable = false,
  }) async {
    final modal = BaseModal(
      title: title,
      content: content,
      actions: actions,
      onClose: onClose,
      showCloseButton: showCloseButton,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      isScrollable: isScrollable,
    );

    if (isDesktop) {
      return await showDialog<T>(context: context, builder: (context) => modal);
    } else {
      return await showModalBottomSheet<T>(
        context: AppRouter.rootNavigatorKey.currentContext!,
        isScrollControlled: true,
        builder: (context) => modal,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopDialog(context);
    } else {
      return _buildMobileSheet(context);
    }
  }

  Widget _buildDesktopDialog(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? AppConstants.modalMaxWidth,
          maxHeight: maxHeight ?? AppConstants.modalMaxHeight,
        ),
        padding: AppConstants.padding(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            AppConstants.spacingY(AppConstants.spacingMd),
            Flexible(child: SingleChildScrollView(child: content)),
            if (actions != null) ...[
              AppConstants.spacingY(AppConstants.spacingLg),
              actions!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSheet(BuildContext context) {
    if (isScrollable) {
      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).bottomSheetTheme.backgroundColor ??
                  Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusBottomSheet),
              ),
            ),
            child: Column(
              children: [
                _buildDragHandle(context),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: AppConstants.padding(AppConstants.spacingLg),
                    children: [
                      _buildHeader(context),
                      AppConstants.spacingY(AppConstants.spacingMd),
                      content,
                      if (actions != null) ...[
                        AppConstants.spacingY(AppConstants.spacingLg),
                        actions!,
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).bottomSheetTheme.backgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusBottomSheet),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: AppConstants.paddingOnly(
                  top: AppConstants.spacing8,
                  left: AppConstants.spacingMd,
                  right: AppConstants.spacingMd,
                  bottom: AppConstants.spacingMd,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDragHandle(context),
                    SizedBox(height: AppConstants.spacing8),
                    _buildHeader(context),
                  ],
                ),
              ),

              Padding(
                padding: AppConstants.padding(AppConstants.spacingLg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    if (actions != null) ...[
                      AppConstants.spacingY(AppConstants.spacingLg),
                      actions!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showCloseButton)
          const SizedBox(
            width: 36,
          ), // Match close button width (20 icon + 8*2 padding)
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleSmall(),
          ),
        ),
        if (showCloseButton)
          InkWell(
            onTap:
                onClose ??
                () => Navigator.of(context, rootNavigator: true).pop(),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            child: Padding(
              padding: AppConstants.padding(AppConstants.spacing8),
              child: const Icon(LucideIcons.x, size: 20),
            ),
          ),
      ],
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
