import 'package:desterlib_client/core/app/app.dart';
import 'package:desterlib_client/core/icons/dark_mode_icon.dart';
import 'package:desterlib_client/core/icons/light_mode_icon.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:flutter/widgets.dart';

class ThemeToggleActionButton extends StatelessWidget {
  const ThemeToggleActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeScope.of(context);
    final themeController = AppThemeScope.controllerOf(context);

    return ActionButton(
      onPressed: themeController.toggle,
      icon: (context, color, size, iconKey) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 120),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: theme.isDark
              ? DarkModeIcon(
                  color: color,
                  size: size,
                  key: const ValueKey('dark'),
                )
              : LightModeIcon(
                  color: color,
                  size: size,
                  key: const ValueKey('light'),
                ),
        );
      },
    );
  }
}
