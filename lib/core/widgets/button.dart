import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'triggerable_icon.dart';

enum ButtonVariant { primary, secondary, ghost }

extension ButtonVariantStyle on ButtonVariant {
  Color get backgroundColor {
    return switch (this) {
      ButtonVariant.primary => const Color(0xFFFFFFFF),
      ButtonVariant.secondary => const Color.fromARGB(100, 0, 0, 0),
      ButtonVariant.ghost => const Color(0x00000000),
    };
  }

  Color get foregroundColor {
    return switch (this) {
      ButtonVariant.primary => const Color(0xFF000000),
      ButtonVariant.secondary => const Color(0xFFFFFFFF),
      ButtonVariant.ghost => const Color(0x99FFFFFF),
    };
  }

  Color get hoverColor {
    return switch (this) {
      ButtonVariant.primary => const Color(0xFFF2F2F2),
      ButtonVariant.secondary => const Color.fromARGB(125, 0, 0, 0),
      ButtonVariant.ghost => const Color(0x0FFFFFFF),
    };
  }

  Color get pressedColor {
    return switch (this) {
      ButtonVariant.primary => const Color(0xFFE8E8E8),
      ButtonVariant.secondary => const Color.fromARGB(100, 0, 0, 0),
      ButtonVariant.ghost => const Color(0x18FFFFFF),
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
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  final IconBuilder? icon;
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _hovered = false;
  bool _pressed = false;

  final _iconKey = GlobalKey();

  Color get _backgroundColor {
    if (_pressed) return widget.variant.pressedColor;
    if (_hovered) return widget.variant.hoverColor;
    return widget.variant.backgroundColor;
  }

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

  Widget _buildSurface(Color color) {
    final surface = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: widget.variant == ButtonVariant.secondary
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: _buildContents(color),
            )
          : _buildContents(color),
    );

    return Container(
      height: 40,
      decoration: ShapeDecoration(
        shadows: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: surface,
    );
  }

  Widget _buildContents(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: _backgroundColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (widget.icon != null) widget.icon!(context, color, 20, _iconKey),
          Transform.translate(
            offset: const Offset(0, -1.5),
            child: Text(
              widget.label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final color = widget.variant.foregroundColor;

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
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: _buildSurface(color),
        ),
      ),
    );
  }
}
