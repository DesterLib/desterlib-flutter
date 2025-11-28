// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_slider.dart';

/// Slider widget with value display for use in settings
/// Wraps DSlider and adds a value display on the right
class SettingsSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double)? labelBuilder;
  final bool enabled;
  final void Function(double)? onChanged;

  const SettingsSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.labelBuilder,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = labelBuilder?.call(value) ?? value.toInt().toString();

    return Padding(
      padding: AppConstants.paddingX(AppConstants.spacing16),
      child: Row(
        children: [
          Expanded(
            child: DSlider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              labelBuilder: labelBuilder,
              enabled: enabled,
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: AppConstants.spacing4),
          Container(
            alignment: Alignment.center,
            width: AppConstants.spacing24,
            child: Text(
              displayValue,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium().copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
