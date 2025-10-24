import 'package:flutter/material.dart';

class DBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;

  const DBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.white.withValues(alpha: 0.9),
          fontSize: fontSize ?? 13,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1,
        ),
      ),
    );
  }
}
