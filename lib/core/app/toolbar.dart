import 'package:desterlib_client/core/icons/back_arrow_icon.dart';
import 'package:desterlib_client/core/icons/link_icon.dart';
import 'package:desterlib_client/core/icons/refresh_icon.dart';
import 'package:desterlib_client/core/icons/video_mode_icon.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:desterlib_client/features/search/search_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).state.uri.path;
    final isHome = location == '/';

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
                    return LinkIcon(color: color, size: size, key: iconKey);
                  },
                ),
                ActionButton(
                  onPressed: () {
                    print('Refresh pressed');
                  },
                  icon: (context, color, size, iconKey) {
                    return VideoModeIcon(
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
                    return RefreshIcon(color: color, size: size, key: iconKey);
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
                color: Color(0x33FFFFFF),
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
                        duration: const Duration(milliseconds: 100),
                        child: isHome
                            ? const SizedBox.shrink(key: ValueKey('empty'))
                            : ActionButton(
                                key: const ValueKey('back'),
                                onPressed: () => context.go('/'),
                                icon: (context, color, size, iconKey) {
                                  return BackArrowIcon(
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
