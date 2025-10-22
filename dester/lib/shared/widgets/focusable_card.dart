import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A card widget that supports keyboard/D-pad navigation with visual focus indicators
class FocusableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;

  const FocusableCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.autofocus = false,
    this.focusNode,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation = 1,
    this.borderRadius,
    super.key,
  });

  @override
  State<FocusableCard> createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      // Handle activation keys
      if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onTap?.call();
        return KeyEventResult.handled;
      }

      // Handle arrow keys for directional navigation
      if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        // Move focus in the direction
        final direction = _getTraversalDirection(event.logicalKey);
        if (direction != null) {
          final moved = node.nearestScope?.focusInDirection(direction) ?? false;
          if (moved) {
            return KeyEventResult.handled;
          }
          // If couldn't move, let the event bubble up (return ignored)
          // This allows parent handlers to catch it (e.g., for up arrow to nav)
        }
      }
    }
    return KeyEventResult.ignored;
  }

  TraversalDirection? _getTraversalDirection(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        return TraversalDirection.up;
      case LogicalKeyboardKey.arrowDown:
        return TraversalDirection.down;
      case LogicalKeyboardKey.arrowLeft:
        return TraversalDirection.left;
      case LogicalKeyboardKey.arrowRight:
        return TraversalDirection.right;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: widget.margin ?? const EdgeInsets.all(8),
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
        },
        onKeyEvent: _handleKeyEvent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            border: _isFocused
                ? Border.all(color: colorScheme.primary, width: 3)
                : null,
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Card(
            elevation: _isFocused ? widget.elevation + 4 : widget.elevation,
            color: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(16),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
