import 'dart:ui';
import 'package:desterlib_client/core/app/app.dart';
import 'package:desterlib_client/core/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:desterlib_client/core/interfaces/triggerable_icon.dart';

enum ButtonVariant { primary, secondary, ghost }

extension ButtonVariantStyle on ButtonVariant {
  Color backgroundColor(AppTheme theme) {
    return switch (this) {
      ButtonVariant.primary => theme.primary,
      ButtonVariant.secondary => theme.secondary,
      ButtonVariant.ghost => theme.ghost,
    };
  }

  Color foregroundColor(AppTheme theme) {
    return switch (this) {
      ButtonVariant.primary => theme.onPrimary,
      ButtonVariant.secondary => theme.onSecondary,
      ButtonVariant.ghost => theme.onGhost,
    };
  }

  Color hoverColor(AppTheme theme) {
    return switch (this) {
      ButtonVariant.primary => theme.primaryHover,
      ButtonVariant.secondary => theme.secondaryHover,
      ButtonVariant.ghost => theme.ghostHover,
    };
  }

  Color pressedColor(AppTheme theme) {
    return switch (this) {
      ButtonVariant.primary => theme.primary,
      ButtonVariant.secondary => theme.secondary,
      ButtonVariant.ghost => theme.ghostHover,
    };
  }

  Color hoverForegroundColor(AppTheme theme) {
    return switch (this) {
      ButtonVariant.primary => theme.onPrimary,
      ButtonVariant.secondary => theme.onSurface,
      ButtonVariant.ghost => theme.onGhostHover,
    };
  }
}

typedef IconBuilder =
    Widget Function(
      BuildContext context,
      Color color,
      double size,
      Key iconKey,
    );

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.icon,
    this.iconSize = 24,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });
  final IconBuilder? icon;
  final double iconSize;
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  static const _duration = Duration(milliseconds: 120);
  static const _curve = Curves.easeOutCubic;

  bool _hovered = false;
  bool _pressed = false;
  final _iconKey = GlobalKey();
  void _handleTap() {
    widget.onPressed?.call();
  }

  void _handleTapDown() {
    setState(() => _pressed = true);
    if (_iconKey.currentState case final TriggerableIcon icon) {
      icon.trigger();
    }
  }

  void _handleTapUp() {
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
  }

  Widget _buildSurface({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    final contents = _buildContents(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
    final surface = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: widget.variant == ButtonVariant.secondary
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: contents,
            )
          : contents,
    );
    final showShadow =
        widget.variant != ButtonVariant.ghost || _hovered || _pressed;
    return AnimatedContainer(
      duration: _duration,
      height: 40,
      decoration: ShapeDecoration(
        shadows: [
          BoxShadow(
            color: const Color(
              0xFF000000,
            ).withValues(alpha: showShadow ? 0.20 : 0.0),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: surface,
    );
  }

  Widget _buildContents({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return AnimatedContainer(
      duration: _duration,
      curve: _curve,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (widget.icon != null)
            widget.icon!(context, foregroundColor, widget.iconSize, _iconKey),
          Transform.translate(
            offset: const Offset(0, -1.5),
            child: AnimatedDefaultTextStyle(
              duration: _duration,
              curve: _curve,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              child: Text(widget.label),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeScope.of(context);
    final enabled = widget.onPressed != null;

    final backgroundColor = switch ((_pressed, _hovered)) {
      (true, _) => widget.variant.pressedColor(theme),
      (false, true) => widget.variant.hoverColor(theme),
      _ => widget.variant.backgroundColor(theme),
    };

    final foregroundColor = switch ((_pressed, _hovered)) {
      (true, _) => widget.variant.hoverForegroundColor(theme),
      (false, true) => widget.variant.hoverForegroundColor(theme),
      _ => widget.variant.foregroundColor(theme),
    };

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled
          ? (_) => setState(() {
              _hovered = false;
              _pressed = false;
            })
          : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? _handleTap : null,
        onTapDown: enabled ? (_) => _handleTapDown() : null,
        onTapUp: enabled ? (_) => _handleTapUp() : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: _duration,
          curve: _curve,
          child: _buildSurface(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          ),
        ),
      ),
    );
  }
}
