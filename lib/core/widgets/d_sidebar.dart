// Dart
import 'dart:io';

// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:ui';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Desktop sidebar navigation widget
class DSidebar extends StatelessWidget {
  final String currentRoute;
  final double width;

  const DSidebar({super.key, required this.currentRoute, this.width = 240});

  /// Check if running on desktop platform
  static bool get isDesktop {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  // Map routes to indices
  int _getCurrentIndex() {
    if (currentRoute == '/') return 0;
    if (currentRoute.startsWith('/settings')) return 1;
    return 0;
  }

  // Map indices to routes
  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/';
      case 1:
        return '/settings';
      default:
        return '/';
    }
  }

  /// Get the total width including padding (for spacing calculations)
  static double getTotalWidth() {
    return 240 +
        (AppConstants.spacing8 * 2); // width + left padding + right padding
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radius2xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppConstants.radius2xl),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: AppConstants.spacingXs,
                  ),
                  children: [
                    _SidebarItem(
                      icon: LucideIcons.house200,
                      selectedIcon: LucideIcons.house300,
                      label: AppLocalization.homeTitle.tr(),
                      isSelected: currentIndex == 0,
                      onTap: () {
                        final route = _getRouteForIndex(0);
                        if (currentRoute != route) {
                          context.go(route);
                        }
                      },
                    ),
                    _SidebarItem(
                      icon: LucideIcons.settings200,
                      selectedIcon: LucideIcons.settings300,
                      label: AppLocalization.settingsTitle.tr(),
                      isSelected: currentIndex == 1,
                      onTap: () {
                        final route = _getRouteForIndex(1);
                        if (currentRoute != route) {
                          context.go(route);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacing8,
        vertical: AppConstants.spacing4,
      ),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacing12,
              vertical: AppConstants.spacing8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected
                      ? Colors.black
                      : Colors.white.withValues(alpha: 0.6),
                  size: 20,
                ),
                const SizedBox(width: AppConstants.spacing12),
                Text(
                  label,
                  style: AppTypography.navLabel(
                    color: isSelected
                        ? Colors.black
                        : Colors.white.withValues(alpha: 0.6),
                    isSelected: isSelected,
                  ).copyWith(letterSpacing: -0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
