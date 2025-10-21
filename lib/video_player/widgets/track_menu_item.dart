import 'package:flutter/material.dart';

/// Desktop track menu item
class TrackMenuItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TrackMenuItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.white.withValues(alpha:  0.15),
          highlightColor: Colors.white.withValues(alpha:  0.1),
          splashColor: Colors.white.withValues(alpha:  0.2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha:  0.1)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha:  0.8),
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
