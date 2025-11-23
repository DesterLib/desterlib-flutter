// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';


class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSettingsGroup),
        ),
      ),
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(AppConstants.radiusSettingsGroup),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
