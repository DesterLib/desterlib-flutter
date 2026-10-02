import 'package:desterlib_client/core/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'triggerable_icon.dart';

typedef IconBuilder =
    Widget Function(
      BuildContext context,
      Color color,
      double size,
      Key iconKey,
    );

class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 32,
    this.iconSize = 24,
    this.hoverScale = 1.1,
    this.pressScale = 0.9,
  });

  final IconBuilder icon;
  final VoidCallback? onPressed;

  final Color? color;
  final double size;
  final double iconSize;
  final double hoverScale;
  final double pressScale;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _hovered = false;
  bool _pressed = false;

  final _iconKey = GlobalKey();

  double get _scale {
    if (_pressed) return widget.pressScale;
    if (_hovered) return widget.hoverScale;
    return 1.0;
  }

  void _handleTap() {
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeScope.of(context);
    final color = widget.color ?? theme.surfaceMedium;

    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: MouseRegion(
          cursor: widget.onPressed != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPressed == null ? null : _handleTap,
            onTapDown: widget.onPressed == null
                ? null
                : (_) {
                    setState(() => _pressed = true);
                    if (_iconKey.currentState case final TriggerableIcon icon) {
                      icon.trigger();
                    }
                  },
            onTapUp: widget.onPressed == null
                ? null
                : (_) => setState(() => _pressed = false),
            onTapCancel: widget.onPressed == null
                ? null
                : () => setState(() => _pressed = false),
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOutCubic,
              child: Center(
                child: widget.icon(context, color, widget.iconSize, _iconKey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
