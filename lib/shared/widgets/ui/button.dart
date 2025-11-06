import 'dart:ui';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final sizeProps = _sizeProperties;

    late _ButtonStyle style;
    switch (widget.variant) {
      case DButtonVariant.primary:
        style = _ButtonStyle(
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderSide: BorderSide.none,
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );
      case DButtonVariant.secondary:
        style = _ButtonStyle(
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          textColor: Colors.grey.shade200,
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );
      case DButtonVariant.ghost:
        style = _ButtonStyle(
          backgroundColor: Colors.transparent,
          textColor: Colors.grey.shade400,
          borderSide: BorderSide.none,
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );
      case DButtonVariant.danger:
        style = _ButtonStyle(
          backgroundColor: Colors.red.withValues(alpha: 0.6),
          textColor: Colors.white,
          borderSide: BorderSide(
            color: Colors.red.withValues(alpha: 0.7),
            width: 1,
          ),
          borderRadius: widget.borderRadius,
          padding: sizeProps.padding,
          alignment: MainAxisAlignment.center,
          iconLabelSpacing: 4,
        );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: style.borderRadius,
        child: widget.variant == DButtonVariant.secondary
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
              )
            : Container(
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
    );
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
