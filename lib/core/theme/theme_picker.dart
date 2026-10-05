import 'package:desterlib_client/core/theme/theme_toggle_action_button.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:desterlib_client/core/widgets/app_icon.dart';
import 'package:desterlib_client/core/widgets/popover.dart';
import 'package:flutter/material.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

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
              return AppIcon(
                icon: AppIcons.brush,
                color: color,
                size: size,
                key: iconKey,
              );
            },
          );
        },
        content: (context, close) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Toggle surface theme',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                ThemeToggleActionButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
