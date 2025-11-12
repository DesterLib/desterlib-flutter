import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/button.dart';

class DButtonGroup extends StatelessWidget {
  final List<DButton> buttons;
  const DButtonGroup({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    if (buttons.isEmpty) return const SizedBox.shrink();
    if (buttons.length == 1) return buttons.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: List.generate(buttons.length, (index) {
        final button = buttons[index];
        final isFirst = index == 0;
        final isLast = index == buttons.length - 1;

        BorderRadius borderRadius;
        if (isFirst) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );
        } else if (isLast) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          );
        } else {
          borderRadius = const BorderRadius.all(Radius.circular(8));
        }
        return DButton(
          label: button.label,
          leftIcon: button.leftIcon,
          rightIcon: button.rightIcon,
          borderRadius: borderRadius,
        );
      }),
    );
  }
}
