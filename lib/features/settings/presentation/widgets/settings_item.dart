// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

class SettingsItem extends StatefulWidget {
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final String title;
  final String? trailingText;
  final TextStyle? trailingTextStyle;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final bool isFirst;

  const SettingsItem({
    super.key,
    this.leadingIcon,
    this.leadingIconColor,
    required this.title,
    this.trailingText,
    this.trailingTextStyle,
    this.trailingIcon,
    this.onTap,
    this.isFirst = false,
  });

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      padding: AppConstants.paddingX(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: _isPressed
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)
            : null,
      ),
      child: SizedBox(
        child: Row(
          children: [
            if (widget.leadingIcon != null) ...[
              Icon(
                widget.leadingIcon,
                size: 24,
                color:
                    widget.leadingIconColor ??
                    Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
              ),
              SizedBox(width: AppConstants.spacing8),
            ],
            Expanded(
              child: Container(
                height: 48,
                alignment: Alignment.centerLeft,
                decoration: widget.isFirst
                    ? null
                    : BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTypography.titleSmall(),
                      ),
                    ),
                    if (widget.trailingText != null) ...[
                      Text(
                        widget.trailingText!,
                        style:
                            widget.trailingTextStyle ??
                            AppTypography.bodySmall(),
                      ),
                      SizedBox(width: AppConstants.spacing8),
                    ],
                    if (widget.trailingIcon != null) ...[
                      Icon(
                        widget.trailingIcon,
                        size: 20,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withValues(alpha: 0.6),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) async {
          widget.onTap!();
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            setState(() => _isPressed = false);
          }
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: content,
      );
    }

    return content;
  }
}
