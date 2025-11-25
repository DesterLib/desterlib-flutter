// External packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:dester/core/widgets/d_icon.dart';

// App
import 'package:dester/app/localization/app_localization.dart';

// Core
import 'package:dester/core/constants/app_typography.dart';

/// Bottom navigation bar widget for app navigation
class DBottomNavigationBar extends StatelessWidget {
  final String currentRoute;

  const DBottomNavigationBar({super.key, required this.currentRoute});

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

  @override
  Widget build(BuildContext context) {
    return DBottomNavBar(
      currentIndex: _getCurrentIndex(),
      onTap: (index) {
        final route = _getRouteForIndex(index);
        if (currentRoute != route) {
          context.go(route);
        }
      },
      items: [
        DBottomNavBarItem(
          icon: DIconName.home,
          selectedIcon: DIconName.home,
          label: AppLocalization.homeTitle.tr(),
        ),
        DBottomNavBarItem(
          icon: DIconName.settings,
          selectedIcon: DIconName.settings,
          label: AppLocalization.settingsTitle.tr(),
        ),
      ],
    );
  }
}

class DBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<DBottomNavBarItem> items;
  final VoidCallback? onSearchTap;

  const DBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.onSearchTap,
  });

  @override
  State<DBottomNavBar> createState() => _DBottomNavBarState();
}

class _DBottomNavBarState extends State<DBottomNavBar> {
  final List<GlobalKey> _itemKeys = [];
  final GlobalKey _stackKey = GlobalKey();
  double _pillLeft = 0;
  double _pillWidth = 84;
  static const double _pillHeight = 60;

  @override
  void initState() {
    super.initState();
    _itemKeys.addAll(List.generate(widget.items.length, (_) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePillPosition());
  }

  @override
  void didUpdateWidget(DBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updatePillPosition();
    }
  }

  void _updatePillPosition() {
    if (!mounted) return;

    final currentKey = _itemKeys[widget.currentIndex];
    final RenderBox? itemBox =
        currentKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? stackBox =
        _stackKey.currentContext?.findRenderObject() as RenderBox?;

    if (itemBox != null && stackBox != null) {
      final itemPosition = itemBox.localToGlobal(Offset.zero);
      final stackPosition = stackBox.localToGlobal(Offset.zero);

      setState(() {
        _pillLeft = itemPosition.dx - stackPosition.dx;
        _pillWidth = itemBox.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 16.0,
          right: 16.0,
          top: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.07),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: _pillHeight,
                        child: Stack(
                          key: _stackKey,
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutCubic,
                              left: _pillLeft,
                              top: 0,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOutCubic,
                                width: _pillWidth,
                                height: _pillHeight,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                widget.items.length,
                                (index) => _NavBarItem(
                                  key: _itemKeys[index],
                                  item: widget.items[index],
                                  isSelected: widget.currentIndex == index,
                                  onTap: () => widget.onTap(index),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.onSearchTap != null) ...[
              const SizedBox(width: 12),
              _SearchButton(onTap: widget.onSearchTap!),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final DBottomNavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return DIcon(
                  filled: item.icon == DIconName.home ? true : false,
                  icon: isSelected ? item.selectedIcon : item.icon,
                  color: Color.lerp(Colors.white, Colors.black, value),
                );
              },
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Text(
                  item.label,
                  style: AppTypography.navLabelSmall(
                    color: Color.lerp(
                      Colors.white.withValues(alpha: 0.55),
                      Colors.black,
                      value,
                    ),
                    isSelected: isSelected,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade800.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade800.withValues(alpha: 0.2),
                width: 0.33,
              ),
            ),
            child: DIcon(
              icon: DIconName.search,
              size: 24.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class DBottomNavBarItem {
  final DIconName icon;
  final DIconName selectedIcon;
  final String label;

  const DBottomNavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
