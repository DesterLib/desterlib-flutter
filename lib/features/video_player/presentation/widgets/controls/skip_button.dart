// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// Skip forward or backward button
class SkipButton extends StatelessWidget {
  final bool isForward;
  final int seconds;
  final VoidCallback onPressed;
  final double? size;
  final Color? color;

  const SkipButton({
    super.key,
    required this.isForward,
    required this.seconds,
    required this.onPressed,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? AppConstants.size2xl;
    final iconSize = buttonSize * 0.5;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            DIcon(
              icon: isForward ? DIconName.forward : DIconName.replay,
              size: iconSize,
              color: color ?? Colors.white,
            ),
            Positioned(
              bottom: buttonSize * 0.25,
              child: Text(
                '$seconds',
                style: TextStyle(
                  color: color ?? Colors.white,
                  fontSize: buttonSize * 0.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
