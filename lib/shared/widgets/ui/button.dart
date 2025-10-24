import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

enum DButtonVariant { primary, secondary, ghost, danger }
enum DButtonSize { sm, md, lg }

class _ButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final MainAxisAlignment alignment;
  final double iconLabelSpacing;

  const _ButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.borderSide,
    required this.borderRadius,
    required this.padding,
    required this.alignment,
    required this.iconLabelSpacing,
  });
}

class DButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final BorderRadius borderRadius;
  final bool fullWidth;
  final DButtonVariant variant;
  final DButtonSize size;
  final VoidCallback? onTap;
  const DButton({
    super.key,
    this.label,
    this.icon,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.fullWidth = false,
    this.variant = DButtonVariant.primary,
    this.size = DButtonSize.md,
    this.onTap,
  });

  @override
  State<DButton> createState() => _DButtonState();
}

class _DButtonState extends State<DButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  ({double iconSize, double fontSize, EdgeInsets padding}) get _sizeProperties {
    switch (widget.size) {
      case DButtonSize.sm:
        return (
          iconSize: 20,
          fontSize: 14,
          padding: EdgeInsets.symmetric(
            horizontal: widget.label != null ? 16 : 8,
            vertical: 8,
          ),
        );
      case DButtonSize.md:
        return (
          iconSize: 24,
          fontSize: 16,
          padding: EdgeInsets.symmetric(
            horizontal: widget.label != null ? 24 : 12,
            vertical: 12,
          ),
        );
      case DButtonSize.lg:
        return (
          iconSize: 28,
          fontSize: 18,
          padding: EdgeInsets.symmetric(
            horizontal: widget.label != null ? 32 : 16,
            vertical: 16,
          ),
        );
    }
  }

  _ButtonStyle get _style {
    final sizeProps = _sizeProperties;
    
    switch (widget.variant) {
      case DButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor: _isHovered ? Colors.grey[300]! : Colors.white,
          textColor: _isHovered ? Colors.grey.shade800 : Colors.black,
          borderSide: BorderSide.none,
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );

      case DButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor: _isHovered
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.1),
          textColor: _isHovered ? Colors.white : Colors.grey.shade200,
          borderSide: BorderSide(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );

      case DButtonVariant.ghost:
        return _ButtonStyle(
          backgroundColor: _isHovered
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.transparent,
          textColor: _isHovered ? Colors.white : Colors.grey.shade400,
          borderSide: BorderSide.none,
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );

      case DButtonVariant.danger:
        return _ButtonStyle(
          backgroundColor: _isHovered
              ? Colors.red.withValues(alpha: 0.8)
              : Colors.red.withValues(alpha: 0.6),
          textColor: Colors.white,
          borderSide: BorderSide(
            color: _isHovered
                ? Colors.red.withValues(alpha: 0.9)
                : Colors.red.withValues(alpha: 0.7),
            width: 1,
          ),
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;

    Widget buttonContent = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Listener(
        onPointerDown: (_) {
          HapticFeedback.lightImpact();
          setState(() => _isPressed = true);
        },
        onPointerUp: (_) => setState(() => _isPressed = false),
        onPointerCancel: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed
              ? 0.98
              : _isHovered
              ? 1.02
              : 1.0,
          duration: const Duration(milliseconds: 100),
          child: widget.variant == DButtonVariant.secondary
              ? ClipRRect(
                  borderRadius: style.borderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: widget.fullWidth ? double.infinity : null,
                      padding: style.padding,
                      decoration: ShapeDecoration(
                        color: style.backgroundColor,
                        shape: RoundedSuperellipseBorder(
                          borderRadius: style.borderRadius,
                          side: style.borderSide,
                        ),
                      ),
                      child: _buildButtonContent(style),
                    ),
                  ),
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: widget.fullWidth ? double.infinity : null,
                  padding: style.padding,
                  decoration: ShapeDecoration(
                    color: style.backgroundColor,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: style.borderRadius,
                      side: style.borderSide,
                    ),
                  ),
                  child: _buildButtonContent(style),
                ),
        ),
      ),
    );

    // Wrap with GestureDetector if onTap is provided
    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: buttonContent,
      );
    }

    return buttonContent;
  }

  Widget _buildButtonContent(_ButtonStyle style) {
    final sizeProps = _sizeProperties;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: style.alignment,
      children: [
        if (widget.icon != null)
          Icon(widget.icon, size: sizeProps.iconSize, color: style.textColor),
        if (widget.icon != null && widget.label != null)
          SizedBox(width: style.iconLabelSpacing),
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: sizeProps.fontSize,
              letterSpacing: -0.5,
              color: style.textColor,
            ),
          ),
      ],
    );
  }
}
