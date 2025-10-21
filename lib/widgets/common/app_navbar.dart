import 'package:flutter/material.dart';
import 'nav_button.dart';

class AppNavBar extends StatelessWidget {
  final String currentRoute;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppNavBar({
    super.key,
    required this.currentRoute,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NavButton(
                label: 'Home',
                isSelected: currentRoute == '/',
                onTap: () {
                  if (currentRoute != '/') {
                    navigatorKey.currentState?.pushReplacementNamed('/');
                  }
                },
              ),
              const SizedBox(width: 4),
              NavButton(
                label: 'Settings',
                isSelected: currentRoute == '/settings',
                onTap: () {
                  if (currentRoute != '/settings') {
                    navigatorKey.currentState?.pushReplacementNamed(
                      '/settings',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
