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
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLoading;

  const SettingsItem({
    super.key,
    this.leadingIcon,
    this.leadingIconColor,
    required this.title,
    this.trailingText,
    this.trailingTextStyle,
    this.trailingIcon,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    this.isLoading = false,
  });

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: AppConstants.durationFast,
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
              widget.isLoading
                  ? _PulsingIcon(
                      icon: widget.leadingIcon!,
                      color:
                          widget.leadingIconColor ??
                          Theme.of(
                            context,
                          ).iconTheme.color?.withValues(alpha: 0.3),
                    )
                  : Icon(
                      widget.leadingIcon!,
                      size: 24,
                      color:
                          widget.leadingIconColor ??
                          Theme.of(
                            context,
                          ).iconTheme.color?.withValues(alpha: 0.6),
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
                    if (widget.trailing != null) ...[
                      widget.trailing!,
                    ] else if (widget.trailingText != null) ...[
                      Text(
                        widget.trailingText!,
                        style:
                            widget.trailingTextStyle ??
                            AppTypography.bodySmall(),
                      ),
                      SizedBox(width: AppConstants.spacing8),
                    ] else if (widget.trailingIcon != null) ...[
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
          await Future.delayed(AppConstants.durationVeryFast);
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

/// Widget that displays a pulsing icon to indicate loading state
class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color? color;

  const _PulsingIcon({required this.icon, this.color});

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Icon(
          widget.icon,
          size: 24,
          color: (widget.color ?? Theme.of(context).iconTheme.color)
              ?.withValues(alpha: _animation.value),
        );
      },
    );
  }
}
