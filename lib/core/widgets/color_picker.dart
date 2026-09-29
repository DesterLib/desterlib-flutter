import 'package:desterlib_client/core/icons/theme_icon.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:desterlib_client/core/widgets/popover.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Popover(
        width: 260,
        height: 320,
        targetAnchor: Alignment.topCenter,
        followerAnchor: Alignment.bottomCenter,
        offset: const Offset(0, -16),
        trigger: (context, toggle) {
          return ActionButton(
            onPressed: toggle,
            icon: (context, color, size, iconKey) {
              return ThemeIcon(color: color, size: size, key: iconKey);
            },
          );
        },
        content: (context, close) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick a color',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
