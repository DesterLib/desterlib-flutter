// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final Widget group;

  const SettingsSection({super.key, required this.title, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppConstants.paddingX(AppConstants.spacing16),
          child: Text(title, style: AppTypography.titleSmall()),
        ),
        AppConstants.spacingY(AppConstants.spacing8),
        group,
      ],
    );
  }
}
