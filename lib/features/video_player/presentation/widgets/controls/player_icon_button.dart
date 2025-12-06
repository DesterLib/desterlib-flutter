// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// Icon button for player controls (settings, audio, subtitles, etc.)
class PlayerIconButton extends StatelessWidget {
  final DIconName icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double? size;
  final Color? color;
  final Color? backgroundColor;
  final bool showBackground;

  const PlayerIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size,
    this.color,
    this.backgroundColor,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? AppConstants.iconButtonSizeMd;
    final iconSize = buttonSize * 0.5;

    final button = GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: showBackground
              ? (backgroundColor ?? Colors.white.withOpacity(0.15))
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: DIcon(
            icon: icon,
            size: iconSize,
            color: color ?? Colors.white,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
