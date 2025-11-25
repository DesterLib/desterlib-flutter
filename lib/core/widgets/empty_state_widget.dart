// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// Reusable empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final DIconName? icon;
  final Color? iconColor;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppConstants.padding(AppConstants.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DIcon(
              icon: icon ?? DIconName.inbox,
              size: 64.0,
              color: iconColor ?? Colors.grey[400],
            ),
            AppConstants.spacingY(AppConstants.spacing16),
            Text(
              title,
              style: AppTypography.titleLarge(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppConstants.spacingY(AppConstants.spacing8),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              AppConstants.spacingY(AppConstants.spacing24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
