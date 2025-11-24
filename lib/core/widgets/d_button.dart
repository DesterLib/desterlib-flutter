// External packages
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';

/// Button variants
enum DButtonVariant { primary, secondary, plain }

/// Button sizes
enum DButtonSize { sm, md }

/// A customizable button widget with variants, sizes, and blur support
class DButton extends StatefulWidget {
  /// The button label
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button variant (primary, secondary, plain)
  final DButtonVariant variant;

  /// Button size (sm, md)
  final DButtonSize size;

  /// Whether to enable blur effect (default: false)
  final bool blur;

  /// Optional icon to display before the label
  final IconData? leadingIcon;

  /// Optional icon to display after the label
  final IconData? trailingIcon;

  /// Whether the button is disabled
  final bool isDisabled;

  const DButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DButtonVariant.primary,
    this.size = DButtonSize.md,
    this.blur = false,
    this.leadingIcon,
    this.trailingIcon,
    this.isDisabled = false,
  });

  @override
  State<DButton> createState() => _DButtonState();
}

class _DButtonState extends State<DButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _tintAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _tintAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // Subtle scale animation: scale down to 0.97 on press
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isDisabled || widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isDisabled || widget.onPressed == null) return;
    // Delay the reverse slightly to ensure animation is visible even on quick taps
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.reverse();
      }
    });
  }

  void _handleTapCancel() {
    if (widget.isDisabled || widget.onPressed == null) return;
    _animationController.reverse();
  }

  void _handleTap() {
    if (widget.isDisabled || widget.onPressed == null) return;
    widget.onPressed?.call();
  }

  /// Get horizontal padding based on size
  double _getHorizontalPadding() {
    switch (widget.size) {
      case DButtonSize.sm:
        return AppConstants.spacing12;
      case DButtonSize.md:
        return AppConstants.spacing16;
    }
  }

  /// Get height based on size
  double _getHeight() {
    switch (widget.size) {
      case DButtonSize.sm:
        return 32;
      case DButtonSize.md:
        return 48;
    }
  }

  /// Get background color based on variant
  Color? _getBackgroundColor() {
    if (widget.isDisabled) {
      return Colors.white.withOpacity(0.05);
    }

    switch (widget.variant) {
      case DButtonVariant.primary:
        return Colors.white;
      case DButtonVariant.secondary:
        return Colors.white.withOpacity(0.13);
      case DButtonVariant.plain:
        return Colors.transparent;
    }
  }

  /// Get text color based on variant
  Color _getTextColor() {
    if (widget.isDisabled) {
      return Colors.white.withOpacity(0.3);
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

  /// Get border based on variant
  Border? _getBorder() {
    if (widget.variant == DButtonVariant.plain) {
      return null;
    }
    return null; // No border for primary and secondary
  }

  /// Get border radius based on variant
  /// Primary and secondary use 50px superellipse, plain has no border radius
  BorderRadius? _getBorderRadius() {
    if (widget.variant == DButtonVariant.plain) {
      return BorderRadius.zero;
    }
    // Superellipse border radius (50px) for primary and secondary
    return BorderRadius.circular(50);
  }

  @override
  Widget build(BuildContext context) {
    final baseBackgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();
    final border = _getBorder();
    final horizontalPadding = _getHorizontalPadding();
    final borderRadius = _getBorderRadius();
    final height = _getHeight();

    Widget buttonContent = AnimatedBuilder(
      animation: _tintAnimation,
      builder: (context, child) {
        // For secondary buttons, animate the background opacity directly
        Color? animatedBackgroundColor;
        if (widget.variant == DButtonVariant.secondary && !widget.isDisabled) {
          final baseOpacity = 0.13;
          final pressedOpacity = 0.25;
          final currentOpacity =
              baseOpacity +
              (pressedOpacity - baseOpacity) * _tintAnimation.value;
          animatedBackgroundColor = Colors.white.withOpacity(currentOpacity);
        } else {
          animatedBackgroundColor = baseBackgroundColor;
        }

        return Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: animatedBackgroundColor,
            border: border,
            borderRadius: borderRadius,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.leadingIcon != null) ...[
                    Icon(
                      widget.leadingIcon,
                      size: AppConstants.sizeLg,
                      color: textColor,
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: AppConstants.sizeSm,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (widget.trailingIcon != null) ...[
                    const SizedBox(width: AppConstants.spacing8),
                    Icon(
                      widget.trailingIcon,
                      size: AppConstants.sizeSm,
                      color: textColor,
                    ),
                  ],
                ],
              ),
              // White tint overlay for primary buttons
              if (widget.variant == DButtonVariant.primary)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(_tintAnimation.value * 0.2),
                    borderRadius: borderRadius,
                  ),
                ),
            ],
          ),
        );
      },
    );

    // Apply blur if enabled
    if (widget.blur) {
      buttonContent = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: buttonContent,
        ),
      );
    }

    return Opacity(
      opacity: widget.isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: buttonContent,
            );
          },
        ),
      ),
    );
  }
}
