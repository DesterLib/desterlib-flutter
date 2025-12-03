// External packages
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// Button variants
enum DButtonVariant { primary, secondary, plain }

/// Button sizes
enum DButtonSize { sm, md }

/// A customizable button widget with variants, sizes, and blur support
class DButton extends StatefulWidget {
  /// The button label
  final String? label;

  /// Custom child widget (overrides label and icons)
  final Widget? child;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button variant (primary, secondary, plain)
  final DButtonVariant variant;

  /// Button size (sm, md)
  final DButtonSize size;

  /// Whether to enable blur effect (default: false)
  final bool blur;

  /// Optional icon to display before the label
  final DIconName? leadingIcon;

  /// Optional icon to display after the label
  final DIconName? trailingIcon;

  /// Whether the leading icon should be filled (for play icon, etc.)
  final bool leadingIconFilled;

  /// Whether the button is disabled
  final bool isDisabled;

  const DButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = DButtonVariant.primary,
    this.size = DButtonSize.md,
    this.blur = false,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingIconFilled = false,
    this.isDisabled = false,
  }) : assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  @override
  State<DButton> createState() => _DButtonState();
}

class _DButtonState extends State<DButton> {
  bool _buttonHeldDown = false;
  DateTime? _tapDownTime;
  Timer? _resetTimer;

  bool get _enabled => !widget.isDisabled && widget.onPressed != null;

  void _handleTapDown(TapDownDetails details) {
    if (!_enabled) return;
    _tapDownTime = DateTime.now();
    setState(() {
      _buttonHeldDown = true;
    });
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_enabled) return;
    _resetButtonState();
  }

  void _handleTapCancel() {
    if (!_enabled) return;
    _resetButtonState();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _resetButtonState() {
    if (_tapDownTime == null) return;

    // Cancel any existing timer
    _resetTimer?.cancel();

    final tapDuration = DateTime.now().difference(_tapDownTime!);
    final minDuration = AppConstants.buttonAnimationDuration;

    if (tapDuration < minDuration) {
      // Quick tap - ensure animation is visible for minimum duration
      _resetTimer = Timer(minDuration - tapDuration, () {
        if (mounted) {
          setState(() {
            _buttonHeldDown = false;
            _tapDownTime = null;
          });
        }
      });
    } else {
      // Normal tap - reset immediately
      setState(() {
        _buttonHeldDown = false;
        _tapDownTime = null;
      });
    }
  }

  void _handleTap() {
    if (!_enabled) return;
    widget.onPressed?.call();
  }

  /// Get horizontal padding based on size
  double _getHorizontalPadding() {
    switch (widget.size) {
      case DButtonSize.sm:
        return AppConstants.buttonPaddingHorizontalSm;
      case DButtonSize.md:
        return AppConstants.buttonPaddingHorizontalMd;
    }
  }

  /// Get height based on size
  double _getHeight() {
    switch (widget.size) {
      case DButtonSize.sm:
        return AppConstants.buttonHeightSm;
      case DButtonSize.md:
        return AppConstants.buttonHeightMd;
    }
  }

  /// Get background color based on variant
  Color? _getBackgroundColor() {
    if (widget.isDisabled) {
      return Colors.white.withValues(alpha: 0.05);
    }

    switch (widget.variant) {
      case DButtonVariant.primary:
        return Colors.white;
      case DButtonVariant.secondary:
        return Colors.white.withValues(alpha: 0.13);
      case DButtonVariant.plain:
        return Colors.transparent;
    }
  }

  /// Get text color based on variant
  Color _getTextColor() {
    if (widget.isDisabled) {
      return Colors.white.withValues(alpha: 0.3);
    }

    switch (widget.variant) {
      case DButtonVariant.primary:
        return Colors.black;
      case DButtonVariant.secondary:
        return Colors.white;
      case DButtonVariant.plain:
        return Colors.white;
    }
  }

  /// Get border radius based on variant
  /// Primary and secondary use 50px superellipse, plain has no border radius
  BorderRadius? _getBorderRadius() {
    if (widget.variant == DButtonVariant.plain) {
      return BorderRadius.zero;
    }
    // Superellipse border radius (50px) for primary and secondary
    return BorderRadius.circular(AppConstants.buttonBorderRadiusPill);
  }

  /// Get text style based on size
  TextStyle _getTextStyle(Color color) {
    switch (widget.size) {
      case DButtonSize.sm:
        return AppTypography.buttonSmall(color: color);
      case DButtonSize.md:
        return AppTypography.buttonMedium(color: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cache computed values to avoid recalculating on every build
    final baseBackgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();
    final textStyle = _getTextStyle(textColor);
    final horizontalPadding = _getHorizontalPadding();
    final borderRadius = _getBorderRadius();
    final height = _getHeight();
    final isDisabled = widget.isDisabled;

    // Build static content that doesn't change with _buttonHeldDown
    final buttonContent = Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: baseBackgroundColor,
        borderRadius: borderRadius,
      ),
      child:
          widget.child ??
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.leadingIcon != null) ...[
                DIcon(
                  icon: widget.leadingIcon!,
                  size: AppConstants.buttonIconSizeLeading,
                  color: textColor,
                  filled: widget.leadingIconFilled,
                ),
                const SizedBox(width: AppConstants.buttonIconSpacing),
              ],
              Text(widget.label!, style: textStyle),
              if (widget.trailingIcon != null) ...[
                const SizedBox(width: AppConstants.buttonIconSpacing),
                DIcon(
                  icon: widget.trailingIcon!,
                  size: AppConstants.buttonIconSizeTrailing,
                  color: textColor,
                ),
              ],
            ],
          ),
    );

    // Apply blur if enabled
    final finalButtonContent = widget.blur
        ? ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: buttonContent,
            ),
          )
        : buttonContent;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? _handleTapDown : null,
        onTapUp: _enabled ? _handleTapUp : null,
        onTapCancel: _enabled ? _handleTapCancel : null,
        onTap: _handleTap,
        child: AnimatedOpacity(
          duration: AppConstants.buttonAnimationDuration,
          opacity: _buttonHeldDown ? 0.6 : 1.0,
          child: finalButtonContent,
        ),
      ),
    );
  }
}
