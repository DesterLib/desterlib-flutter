// External packages
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// Button variants
enum DIconButtonVariant { primary, secondary, plain }

/// Button sizes
enum DIconButtonSize { sm, md }

/// A customizable icon button widget with variants, sizes, and blur support
class DIconButton extends StatefulWidget {
  /// The icon to display
  final DIconName icon;

  /// Whether the icon should be filled (for play icon, etc.)
  final bool filled;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button variant (primary, secondary, plain)
  final DIconButtonVariant variant;

  /// Button size (sm, md)
  final DIconButtonSize size;

  /// Whether to enable blur effect (default: false)
  final bool blur;

  /// Whether the button is disabled
  final bool isDisabled;

  const DIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = DIconButtonVariant.primary,
    this.size = DIconButtonSize.md,
    this.blur = false,
    this.filled = false,
    this.isDisabled = false,
  });

  @override
  State<DIconButton> createState() => _DIconButtonState();
}

class _DIconButtonState extends State<DIconButton> {
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
    final minDuration = AppConstants.iconButtonAnimationDuration;

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

  /// Get size (width and height) based on size variant
  /// Icon buttons are square, so width equals height
  double _getSize() {
    switch (widget.size) {
      case DIconButtonSize.sm:
        return AppConstants.iconButtonSizeSm;
      case DIconButtonSize.md:
        return AppConstants.iconButtonSizeMd;
    }
  }

  /// Get icon size based on button size
  double _getIconSize() {
    switch (widget.size) {
      case DIconButtonSize.sm:
        return AppConstants.iconButtonIconSizeMd;
      case DIconButtonSize.md:
        return AppConstants.iconButtonIconSizeMd;
    }
  }

  /// Get background color based on variant
  Color? _getBackgroundColor() {
    if (widget.isDisabled) {
      return Colors.white.withValues(alpha: 0.05);
    }

    switch (widget.variant) {
      case DIconButtonVariant.primary:
        return Colors.white;
      case DIconButtonVariant.secondary:
        return Colors.white.withValues(alpha: 0.13);
      case DIconButtonVariant.plain:
        return Colors.transparent;
    }
  }

  /// Get icon color based on variant
  Color _getIconColor() {
    if (widget.isDisabled) {
      return Colors.white.withValues(alpha: 0.3);
    }

    switch (widget.variant) {
      case DIconButtonVariant.primary:
        return Colors.black;
      case DIconButtonVariant.secondary:
        return Colors.white;
      case DIconButtonVariant.plain:
        return Colors.white;
    }
  }

  /// Get border radius - always fully rounded (50px) for all icon button variants
  BorderRadius _getBorderRadius() {
    return BorderRadius.circular(AppConstants.iconButtonBorderRadius);
  }

  @override
  Widget build(BuildContext context) {
    // Cache computed values to avoid recalculating on every build
    final baseBackgroundColor = _getBackgroundColor();
    final iconColor = _getIconColor();
    final borderRadius = _getBorderRadius();
    final size = _getSize();
    final iconSize = _getIconSize();
    final isDisabled = widget.isDisabled;

    // Build static content that doesn't change with _buttonHeldDown
    // ClipRRect ensures rounded corners are visible even with transparent backgrounds
    final buttonContent = ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: baseBackgroundColor,
          borderRadius: borderRadius,
        ),
        child: DIcon(
          icon: widget.icon,
          size: iconSize,
          color: iconColor,
          filled: widget.filled,
        ),
      ),
    );

    // Apply blur if enabled
    final finalButtonContent = widget.blur
        ? ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: buttonContent,
            ),
          )
        : buttonContent;

    // Match DButton structure: Opacity (disabled) > GestureDetector > AnimatedOpacity (pressed)
    // When onPressed is null, don't wrap in GestureDetector to allow parent widgets to handle taps
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: widget.onPressed != null && !isDisabled
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: _handleTap,
              child: AnimatedOpacity(
                duration: AppConstants.iconButtonAnimationDuration,
                opacity: _buttonHeldDown ? 0.6 : 1.0,
                child: finalButtonContent,
              ),
            )
          : AnimatedOpacity(
              duration: AppConstants.iconButtonAnimationDuration,
              opacity: _buttonHeldDown ? 0.6 : 1.0,
              child: finalButtonContent,
            ),
    );
  }
}
