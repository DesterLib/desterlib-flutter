// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

class SettingsGroup extends StatelessWidget {
  final String? helperText;
  final List<Widget> children;

  const SettingsGroup({super.key, this.helperText, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: ShapeDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.radiusSettingsGroup,
              ),
            ),
          ),
          child: ClipRSuperellipse(
            borderRadius: BorderRadius.circular(
              AppConstants.radiusSettingsGroup,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
        ),
        if (helperText != null) ...[
          Padding(
            padding: AppConstants.paddingOnly(
              top: AppConstants.spacing8,
              bottom: AppConstants.spacing8,
              left: AppConstants.spacing16,
              right: AppConstants.spacing16,
            ),
            child: Text(helperText!, style: AppTypography.bodySmall()),
          ),
        ],
      ],
    );
  }
}
