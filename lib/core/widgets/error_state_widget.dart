// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Reusable error state widget
class ErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final IconData? icon;
  final Color? iconColor;

  const ErrorStateWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.retryLabel,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppConstants.padding(AppConstants.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: iconColor ?? Colors.red[300],
            ),
            AppConstants.spacingY(AppConstants.spacing16),
            Text(
              error.startsWith('Error:') ? error : 'Error: $error',
              style: AppTypography.bodyMedium(color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppConstants.spacingY(AppConstants.spacing16),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryLabel ?? AppLocalization.homeRetry.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
