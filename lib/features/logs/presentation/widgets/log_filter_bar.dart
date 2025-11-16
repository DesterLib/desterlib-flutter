import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/ui/button.dart';

class LogFilterBar extends StatelessWidget {
  final String? selectedLevel;
  final Function(String?) onLevelChanged;
  final int totalCount;
  final int filteredCount;

  const LogFilterBar({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
    required this.totalCount,
    required this.filteredCount,
  });

  @override
  Widget build(BuildContext context) {
    final levels = ['all', 'error', 'warn', 'info', 'http', 'debug'];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: levels.map((level) {
                  final isSelected =
                      (level == 'all' && selectedLevel == null) ||
                      selectedLevel == level;

                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: DButton(
                      label: level.toUpperCase(),
                      variant: isSelected
                          ? DButtonVariant.primary
                          : DButtonVariant.ghost,
                      size: DButtonSize.sm,
                      onTap: () {
                        onLevelChanged(level == 'all' ? null : level);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          AppSpacing.gapHorizontalSM,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              '$filteredCount / $totalCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
                letterSpacing: 0.3,
              ),
            ),
          ),
          AppSpacing.gapHorizontalXS,
        ],
      ),
    );
  }
}
