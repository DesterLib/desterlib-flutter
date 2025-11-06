import 'dart:ui';
import 'package:flutter/material.dart';

class DBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;
  final bool useBlur;

  const DBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.useBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.15),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: (fontSize ?? 13) + 2,
              color: textColor ?? Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor ?? Colors.white.withValues(alpha: 0.9),
              fontSize: fontSize ?? 13,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              height: 1,
            ),
          ),
        ],
      ),
    );

    if (useBlur) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: content,
        ),
      );
    }

    return content;
  }
}
