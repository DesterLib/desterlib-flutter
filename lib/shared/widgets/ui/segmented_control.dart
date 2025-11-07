import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';

/// A segmented control widget for selecting between options
class DSegmentedControl<T> extends StatelessWidget {
  final T? value;
  final List<SegmentedOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  const DSegmentedControl({
    super.key,
    required this.value,
    required this.options,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use grid layout if more than 2 options or if narrow screen
          final useGrid = options.length > 2 || constraints.maxWidth < 400;

          if (useGrid) {
            return _buildGrid();
          } else {
            return _buildRow();
          }
        },
      ),
    );
  }

  Widget _buildRow() {
    return Row(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = value == option.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < options.length - 1 ? AppSpacing.xxs : 0,
            ),
            child: _SegmentButton(
              label: option.label,
              icon: option.icon,
              isSelected: isSelected,
              enabled: enabled,
              onTap: () {
                if (enabled && onChanged != null) {
                  onChanged!(option.value);
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid() {
    // Build rows of 2 items each
    final rows = <Widget>[];
    for (var i = 0; i < options.length; i += 2) {
      final firstOption = options[i];
      final secondOption = i + 1 < options.length ? options[i + 1] : null;

      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 < options.length ? AppSpacing.xxs : 0,
          ),
          child: Row(
            children: [
              Expanded(
                child: _SegmentButton(
                  label: firstOption.label,
                  icon: firstOption.icon,
                  isSelected: value == firstOption.value,
                  enabled: enabled,
                  onTap: () {
                    if (enabled && onChanged != null) {
                      onChanged!(firstOption.value);
                    }
                  },
                ),
              ),
              if (secondOption != null) ...[
                const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: _SegmentButton(
                    label: secondOption.label,
                    icon: secondOption.icon,
                    isSelected: value == secondOption.value,
                    enabled: enabled,
                    onTap: () {
                      if (enabled && onChanged != null) {
                        onChanged!(secondOption.value);
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

/// Individual segment button
class _SegmentButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.black : AppColors.textSecondary,
              ),
              AppSpacing.gapHorizontalXS,
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Option for segmented control
class SegmentedOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SegmentedOption({required this.value, required this.label, this.icon});
}
