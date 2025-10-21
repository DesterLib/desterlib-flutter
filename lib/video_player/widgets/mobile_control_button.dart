import 'package:flutter/material.dart';

/// Mobile-optimized control button with circular background
class MobileControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const MobileControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: Colors.white.withOpacity( 0.2),
        highlightColor: Colors.white.withOpacity( 0.1),
        hoverColor: Colors.white.withOpacity( 0.15),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity( 0.4),
          ),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}
