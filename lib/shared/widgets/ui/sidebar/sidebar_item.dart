import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DSidebarItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const DSidebarItem({
    super.key,
    required this.label,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<DSidebarItem> createState() => _DSidebarItemState();
}

class _DSidebarItemState extends State<DSidebarItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isActive
        ? (_isHovered ? Colors.grey[200]! : Colors.white)
        : (_isHovered
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent);

    final textColor = widget.isActive ? Colors.black : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Listener(
          onPointerDown: (_) {
            HapticFeedback.lightImpact();
            setState(() => _isPressed = true);
          },
          onPointerUp: (_) => setState(() => _isPressed = false),
          onPointerCancel: (_) => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed
                ? 0.98
                : _isHovered
                ? 1.02
                : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: ShapeDecoration(
                color: backgroundColor,
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: widget.isActive
                          ? (_isHovered
                                ? Colors.black.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.08))
                          : Colors.white.withValues(alpha: 0.1),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Icon(widget.icon, size: 20, color: textColor),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.5,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
