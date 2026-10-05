import 'package:desterlib_client/core/app/app.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:desterlib_client/core/widgets/app_icon.dart';
import 'package:desterlib_client/features/search/search_bar.dart';
import 'package:desterlib_client/core/app/app_background_state.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key, required this.background});

  final AppBackgroundState background;

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).state.uri.path;
    final isHome = location == '/';

    final theme = AppThemeScope.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        spacing: 12,
        children: [
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                ActionButton(
                  onPressed: () {
                    print('Refresh pressed');
                  },
                  icon: (context, color, size, iconKey) {
                    return AppIcon(
                      icon: AppIcons.link,
                      color: color,
                      size: size,
                      key: iconKey,
                    );
                  },
                ),
                ActionButton(
                  onPressed: () {
                    print('Refresh pressed');
                  },
                  icon: (context, color, size, iconKey) {
                    return AppIcon(
                      icon: AppIcons.link,
                      color: color,
                      size: size,
                      key: iconKey,
                    );
                  },
                ),
                ActionButton(
                  onPressed: () {
                    print('Refresh pressed');
                  },
                  icon: (context, color, size, iconKey) {
                    return AppIcon(
                      icon: AppIcons.refresh,
                      color: color,
                      size: size,
                      key: iconKey,
                      rotateAnimate: true,
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
            width: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.surfaceMedium,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(child: SearchBar()),
                Positioned(
                  left: 0,
                  child: Row(
                    spacing: 12,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 120),
                        child: isHome
                            ? const SizedBox.shrink(key: ValueKey('empty'))
                            : ActionButton(
                                key: const ValueKey('back'),
                                onPressed: () {
                                  background.reset();
                                  context.go('/');
                                },
                                icon: (context, color, size, iconKey) {
                                  return AppIcon(
                                    icon: AppIcons.arrowLeft,
                                    color: color,
                                    size: size,
                                    key: iconKey,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
