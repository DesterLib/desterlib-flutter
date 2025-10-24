import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DSettingsItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isActive;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const DSettingsItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.isActive = false,
    this.borderRadius,
    this.padding,
  });

  @override
  State<DSettingsItem> createState() => _DSettingsItemState();
}

class _DSettingsItemState extends State<DSettingsItem> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isActive
        ? Colors.white
        : Colors.white.withValues(alpha: 0.1);

    final textColor = widget.isActive ? Colors.black : Colors.white;
    final subtitleColor = widget.isActive
        ? Colors.black.withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.7);

    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      onTapDown: widget.enabled
          ? (_) {
              HapticFeedback.lightImpact();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedSuperellipseBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            // Icon
            if (widget.icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: widget.isActive
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.1),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Icon(widget.icon, size: 20, color: textColor),
              ),
              const SizedBox(width: 12),
            ],

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.5,
                      color: textColor,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        letterSpacing: -0.1,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing widget
            if (widget.trailing != null) ...[
              const SizedBox(width: 12),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
