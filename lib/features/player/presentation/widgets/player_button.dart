import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Size variants for video player buttons
enum VideoPlayerButtonSize {
  /// Standard size - 48x48 with 24px icon
  standard,

  /// Large size - 64x64 with 32px icon (for center play button)
  large,

  /// Extra large size - 80x80 with 40px icon (for emphasized actions)
  extraLarge,
}

/// Custom button for video player controls with platform-aware styling
class VideoPlayerButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final VideoPlayerButtonSize size;
  final Color? iconColor;
  final Color? textColor;
  final String? tooltip;
  final bool showShadow;

  const VideoPlayerButton({
    super.key,
    required this.icon,
    this.label,
    required this.onTap,
    this.size = VideoPlayerButtonSize.standard,
    this.iconColor,
    this.textColor,
    this.tooltip,
    this.showShadow = false,
  });

  @override
  State<VideoPlayerButton> createState() => _VideoPlayerButtonState();
}

class _VideoPlayerButtonState extends State<VideoPlayerButton> {
  bool _isPressed = false;

  ({double buttonSize, double iconSize, double fontSize}) get _sizeProperties {
    switch (widget.size) {
      case VideoPlayerButtonSize.standard:
        return (buttonSize: 48.0, iconSize: 24.0, fontSize: 14.0);
      case VideoPlayerButtonSize.large:
        return (buttonSize: 64.0, iconSize: 36.0, fontSize: 16.0);
      case VideoPlayerButtonSize.extraLarge:
        return (buttonSize: 80.0, iconSize: 48.0, fontSize: 18.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = _sizeProperties;
    final iconColor = widget.iconColor ?? Colors.white;
    final textColor = widget.textColor ?? Colors.white;

    Widget buttonContent = Listener(
      onPointerDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.label != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: widget.showShadow
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, size: props.iconSize, color: iconColor),
                    const SizedBox(width: 8),
                    Text(
                      widget.label!,
                      style: TextStyle(
                        color: textColor,
                        fontSize: props.fontSize,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: props.buttonSize,
                height: props.buttonSize,
                decoration: BoxDecoration(
                  boxShadow: widget.showShadow
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: props.iconSize,
                  color: iconColor,
                ),
              ),
      ),
    );

    Widget button = GestureDetector(onTap: widget.onTap, child: buttonContent);

    return widget.tooltip != null
        ? Tooltip(message: widget.tooltip!, child: button)
        : button;
  }
}
