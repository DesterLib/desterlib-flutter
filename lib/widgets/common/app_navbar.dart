import 'package:flutter/material.dart';
import 'tv_nav_button.dart';

class AppNavBar extends StatefulWidget {
  final String currentRoute;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppNavBar({
    super.key,
    required this.currentRoute,
    required this.navigatorKey,
  });

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  final FocusNode _homeFocusNode = FocusNode();
  final FocusNode _settingsFocusNode = FocusNode();

  @override
  void dispose() {
    _homeFocusNode.dispose();
    _settingsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Center(
        child: FocusTraversalGroup(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TvNavButton(
                  label: 'Home',
                  isSelected: widget.currentRoute == '/',
                  focusNode: _homeFocusNode,
                  autofocus: widget.currentRoute == '/',
                  onTap: () {
                    if (widget.currentRoute != '/') {
                      widget.navigatorKey.currentState?.pushReplacementNamed(
                        '/',
                      );
                    }
                  },
                ),
                const SizedBox(width: 4),
                TvNavButton(
                  label: 'Settings',
                  isSelected: widget.currentRoute == '/settings',
                  focusNode: _settingsFocusNode,
                  autofocus: widget.currentRoute == '/settings',
                  onTap: () {
                    if (widget.currentRoute != '/settings') {
                      widget.navigatorKey.currentState?.pushReplacementNamed(
                        '/settings',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
