// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final String? helperText;
  final Widget group;

  const SettingsSection({
    super.key,
    required this.title,
    this.helperText,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppConstants.paddingX(AppConstants.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleSmall()),
              if (helperText != null) ...[
                AppConstants.spacingY(AppConstants.spacing4),
                Text(
                  helperText!,
                  style: AppTypography.bodySmall().copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
        AppConstants.spacingY(AppConstants.spacing8),
        group,
      ],
    );
  }
}
