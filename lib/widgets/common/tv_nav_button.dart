import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A navigation button optimized for both mouse/touch and TV remote control
class TvNavButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final bool autofocus;

  const TvNavButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<TvNavButton> createState() => _TvNavButtonState();
}

class _TvNavButtonState extends State<TvNavButton> {
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

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _internalFocusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        // Handle Enter, Space, or Select (TV remote OK button)
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.select)) {
          widget.onTap();
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
            widget.onTap();
            _internalFocusNode.requestFocus();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Colors.white
                  : _isFocused || _isHovered
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: _isFocused
                  ? Border.all(color: Colors.blue.shade400, width: 2.5)
                  : null,
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
