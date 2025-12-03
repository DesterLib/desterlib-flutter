// Dart
import 'dart:io';
import 'dart:ui';

// External packages
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_icon_button.dart';
import 'package:flutter/material.dart';

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

  /// Maximum width for desktop modal (default: AppConstants.baseModalMaxWidth)
  final double? maxWidth;

  /// Maximum height for desktop modal (default: AppConstants.baseModalMaxHeight)
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
        useSafeArea: true,
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
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radius2xl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? AppConstants.baseModalMaxWidth,
                maxHeight: maxHeight ?? AppConstants.baseModalMaxHeight,
              ),
              padding: AppConstants.padding(AppConstants.spacingSm),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radius2xl),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.07),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isDesktopStyle: true),
                  AppConstants.spacingY(AppConstants.spacingMd),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: AppConstants.padding(AppConstants.spacingSm),
                      child: content,
                    ),
                  ),
                  if (actions != null) ...[
                    AppConstants.spacingY(AppConstants.spacingLg),
                    actions!,
                  ],
                ],
              ),
            ),
          ),
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
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.translucent,
            child: Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).bottomSheetTheme.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.baseModalBorderRadius),
                ),
              ),
              child: Column(
                children: [
                  _buildDragHandle(context),
                  Padding(
                    padding: AppConstants.paddingOnly(
                      left: AppConstants.spacingLg,
                      right: AppConstants.spacingLg,
                    ),
                    child: _buildHeader(context),
                  ),
                  AppConstants.spacingY(AppConstants.spacingMd),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: AppConstants.padding(
                        AppConstants.spacingLg,
                      ).copyWith(top: 0),
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
        },
      );
    } else {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Container(
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
              Flexible(
                child: SingleChildScrollView(
                  padding: AppConstants.padding(
                    AppConstants.spacingLg,
                  ).copyWith(top: 0),
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
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, {bool isDesktopStyle = false}) {
    final textColor = isDesktopStyle ? Colors.white : null;
    final iconColor = isDesktopStyle
        ? Colors.white.withValues(alpha: 0.6)
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showCloseButton)
          const SizedBox(width: AppConstants.baseModalCloseButtonWidth),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleSmall(color: textColor),
          ),
        ),
        if (showCloseButton)
          DIconButton(
            icon: DIconName.close,
            size: DIconButtonSize.sm,
            variant: DIconButtonVariant.plain,
            color: iconColor,
            onPressed:
                onClose ??
                () => Navigator.of(context, rootNavigator: true).pop(),
          ),
      ],
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Container(
      width: AppConstants.baseModalDragHandleWidth,
      height: AppConstants.baseModalDragHandleHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          AppConstants.baseModalDragHandleBorderRadius,
        ),
      ),
    );
  }
}
