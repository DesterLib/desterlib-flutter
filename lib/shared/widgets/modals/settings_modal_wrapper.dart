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
}) {
  final useBottomSheet = _shouldUseBottomSheet(context);

  if (useBottomSheet) {
    return _showSettingsBottomSheet<T>(
      context: context,
      title: title,
      builder: builder,
      isDismissible: isDismissible,
      showCloseButton: showCloseButton,
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
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    useRootNavigator: true,
    builder: (context) => _SettingsModalContainer(
      title: title,
      showCloseButton: showCloseButton,
      isBottomSheet: true,
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
  final Widget child;

  const _SettingsModalContainer({
    required this.title,
    required this.showCloseButton,
    required this.isBottomSheet,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = isBottomSheet
        ? AppSpacing.xl + MediaQuery.of(context).viewPadding.bottom
        : AppSpacing.xl + MediaQuery.of(context).viewInsets.bottom;

    final content = Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: isBottomSheet
            ? AppRadius.radiusTopXL
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
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                top: AppSpacing.xl,
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
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
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

  const _ModalHeader({
    required this.title,
    required this.showCloseButton,
    required this.isBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingXL,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          if (isBottomSheet) ...[
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.radiusXS,
              ),
            ),
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
