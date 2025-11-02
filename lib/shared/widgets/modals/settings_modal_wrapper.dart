import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';

const double _modalMaxWidth = 600.0;
const double _mobileThreshold = 600.0;
const Duration _transitionDuration = Duration(milliseconds: 300);
const Curve _transitionCurve = Curves.easeInOutCubic;

bool _shouldUseBottomSheet(BuildContext context) {
  return MediaQuery.of(context).size.width < _mobileThreshold;
}

Future<T?> showSettingsModal<T>({
  required BuildContext context,
  required String title,
  required Widget Function(BuildContext) builder,
  bool isDismissible = true,
  bool showCloseButton = true,
  double? maxWidth,
  bool useFullscreenOnMobile = false,
}) {
  final useBottomSheet = _shouldUseBottomSheet(context);

  if (useBottomSheet) {
    return _showSettingsBottomSheet<T>(
      context: context,
      title: title,
      builder: builder,
      isDismissible: isDismissible,
      showCloseButton: showCloseButton,
      useFullscreen: useFullscreenOnMobile,
    );
  } else {
    return _showSettingsDialog<T>(
      context: context,
      title: title,
      builder: builder,
      isDismissible: isDismissible,
      showCloseButton: showCloseButton,
      maxWidth: maxWidth,
    );
  }
}

Future<T?> _showSettingsBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget Function(BuildContext) builder,
  required bool isDismissible,
  required bool showCloseButton,
  required bool useFullscreen,
}) {
  // Capture safe area from the original context before modal is shown
  final safeAreaTop = MediaQuery.of(context).padding.top;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible && !useFullscreen,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    useRootNavigator: true,
    builder: (context) => _SettingsModalContainer(
      title: title,
      showCloseButton: showCloseButton,
      isBottomSheet: true,
      useFullscreen: useFullscreen,
      safeAreaTop: safeAreaTop,
      child: builder(context),
    ),
  );
}

Future<T?> _showSettingsDialog<T>({
  required BuildContext context,
  required String title,
  required Widget Function(BuildContext) builder,
  required bool isDismissible,
  required bool showCloseButton,
  double? maxWidth,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: _transitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? _modalMaxWidth),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: _SettingsModalContainer(
              title: title,
              showCloseButton: showCloseButton,
              isBottomSheet: false,
              child: builder(context),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: _transitionCurve,
      );

      final scaleAnimation = Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: _transitionCurve));

      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(scale: scaleAnimation, child: child),
      );
    },
  );
}

class _SettingsModalContainer extends StatelessWidget {
  final String title;
  final bool showCloseButton;
  final bool isBottomSheet;
  final bool useFullscreen;
  final double? safeAreaTop;
  final Widget child;

  const _SettingsModalContainer({
    required this.title,
    required this.showCloseButton,
    required this.isBottomSheet,
    this.useFullscreen = false,
    this.safeAreaTop,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    // Use passed-in safeAreaTop if available, otherwise fall back to MediaQuery
    final effectiveSafeAreaTop =
        safeAreaTop ?? MediaQuery.of(context).padding.top;

    final bottomPadding = isBottomSheet
        ? AppSpacing.xl
        : AppSpacing.xl + viewInsets;

    // Calculate max height based on fullscreen mode
    final maxHeight = useFullscreen && isBottomSheet
        ? screenHeight // Full screen height, content will be pushed inside
        : screenHeight * 0.9;

    final content = Container(
      // In fullscreen mode, use exact height for full screen
      // Otherwise use maxHeight constraint
      height: useFullscreen && isBottomSheet ? maxHeight : null,
      constraints: useFullscreen && isBottomSheet
          ? null
          : BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: isBottomSheet
            ? (useFullscreen
                  ? BorderRadius
                        .zero // No border radius in fullscreen for true edge-to-edge
                  : AppRadius.radiusTopXL)
            : AppRadius.radiusXL,
        border: isBottomSheet
            ? null
            : Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModalHeader(
            title: title,
            showCloseButton: showCloseButton,
            isBottomSheet: isBottomSheet,
            useFullscreen: useFullscreen,
            safeAreaTop: effectiveSafeAreaTop,
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                top: useFullscreen && isBottomSheet ? 0 : AppSpacing.xl,
                bottom: bottomPadding,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );

    if (isBottomSheet) {
      return Padding(
        padding: EdgeInsets.only(bottom: viewInsets),
        child: content,
      );
    }

    return content;
  }
}

class _ModalHeader extends StatelessWidget {
  final String title;
  final bool showCloseButton;
  final bool isBottomSheet;
  final bool useFullscreen;
  final double? safeAreaTop;

  const _ModalHeader({
    required this.title,
    required this.showCloseButton,
    required this.isBottomSheet,
    this.useFullscreen = false,
    this.safeAreaTop,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          // Top spacing based on mode
          if (isBottomSheet && useFullscreen) ...[
            // Fullscreen: just safe area padding, no extra spacing
            SizedBox(height: safeAreaTop ?? 0),
          ] else if (isBottomSheet && !useFullscreen) ...[
            // Regular bottom sheet: standard padding + drag handle
            SizedBox(height: AppSpacing.xl),
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.radiusXS,
              ),
            ),
          ] else ...[
            // Dialog: standard padding
            SizedBox(height: AppSpacing.xl),
          ],
          Row(
            children: [
              Expanded(child: Text(title, style: AppTypography.h3)),
              if (showCloseButton) ...[
                const SizedBox(width: 12),
                _CloseButton(),
              ],
            ],
          ),
        ],
      ),
    );

    // Wrap with SafeArea for bottom sheets to handle status bar/notch
    // But skip SafeArea in fullscreen mode since we handle it manually above
    if (isBottomSheet && !useFullscreen) {
      return SafeArea(
        bottom: false, // Don't apply safe area to bottom (handled elsewhere)
        child: content,
      );
    }

    return content;
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: AppRadius.radiusSM,
        child: Container(
          padding: AppSpacing.paddingXS,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.radiusSM,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: const Icon(
            Icons.close,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class SettingsModalSection extends StatelessWidget {
  final String? label;
  final String? description;
  final Widget child;
  final EdgeInsets? padding;

  const SettingsModalSection({
    super.key,
    this.label,
    this.description,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(label!, style: AppTypography.labelLarge),
            AppSpacing.gapVerticalXS,
          ],
          if (description != null) ...[
            Text(description!, style: AppTypography.labelSmall),
            AppSpacing.gapVerticalXS,
          ],
          child,
        ],
      ),
    );
  }
}

class SettingsModalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool enabled;

  const SettingsModalTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsModalSection(
      label: label,
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: AppTypography.bodyBase,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.bodyBase.copyWith(
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: AppRadius.radiusMD,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMD,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMD,
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMD,
            borderSide: BorderSide(
              color: AppColors.border.withValues(alpha: 0.3),
            ),
          ),
          contentPadding: AppSpacing.paddingMD,
        ),
      ),
    );
  }
}

class SettingsModalActions extends StatelessWidget {
  final List<Widget> actions;
  final MainAxisAlignment alignment;

  const SettingsModalActions({
    super.key,
    required this.actions,
    this.alignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            actions[i],
          ],
        ],
      ),
    );
  }
}

class SettingsModalBanner extends StatelessWidget {
  final String message;
  final SettingsModalBannerType type;
  final IconData? icon;

  const SettingsModalBanner({
    super.key,
    required this.message,
    this.type = SettingsModalBannerType.error,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData defaultIcon;

    switch (type) {
      case SettingsModalBannerType.error:
        color = AppColors.error;
        defaultIcon = Icons.error_outline;
        break;
      case SettingsModalBannerType.warning:
        color = AppColors.warning;
        defaultIcon = Icons.warning_amber_outlined;
        break;
      case SettingsModalBannerType.info:
        color = AppColors.primary;
        defaultIcon = Icons.info_outline;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.radiusMD,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon ?? defaultIcon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

enum SettingsModalBannerType { error, warning, info }
