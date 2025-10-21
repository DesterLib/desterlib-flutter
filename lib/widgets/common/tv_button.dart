import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A TV-optimized button with focus management and visual feedback
class TvButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;
  final bool autofocus;

  const TvButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<TvButton> createState() => _TvButtonState();
}

class _TvButtonState extends State<TvButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _internalFocusNode.hasFocus;
    });
  }

  bool get _isHighlighted => _isFocused || _isHovered;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _internalFocusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.select)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            widget.onPressed();
            _internalFocusNode.requestFocus();
          },
          child: AnimatedScale(
            scale: _isHighlighted ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Colors.blue,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                border: _isFocused
                    ? Border.all(color: Colors.white, width: 2.5)
                    : null,
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: (widget.backgroundColor ?? Colors.blue)
                              .withValues(alpha: 0.6),
                          blurRadius: 12,
                          spreadRadius: 3,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.icon != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.icon,
                            color: widget.foregroundColor ?? Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          DefaultTextStyle(
                            style: TextStyle(
                              color: widget.foregroundColor ?? Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            child: widget.child,
                          ),
                        ],
                      )
                    : DefaultTextStyle(
                        style: TextStyle(
                          color: widget.foregroundColor ?? Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        child: widget.child,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
