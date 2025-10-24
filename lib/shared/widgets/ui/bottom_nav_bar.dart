import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../utils/platform_icons.dart';

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
        ),
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.grey.shade800.withValues(alpha: 0.1),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.grey.shade800.withValues(alpha: 0.2),
                      width: 0.33,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
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
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            widget.items.length,
                            (index) => _NavBarItem(
                              key: _itemKeys[index],
                              item: widget.items[index],
                              isSelected: widget.currentIndex == index,
                              onTap: () => widget.onTap(index),
                            ),
                          ),
                          if (widget.onSearchTap != null) ...[
                            const SizedBox(width: 12),
                            _SearchButton(onTap: widget.onSearchTap!),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  color: Color.lerp(Colors.white, Colors.black, value),
                  size: 28,
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
                  style: TextStyle(
                    color: Color.lerp(
                      Colors.white.withValues(alpha: 0.55),
                      Colors.black,
                      value,
                    ),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
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
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 0.33,
          ),
        ),
        child: Icon(PlatformIcons.search, color: Colors.white, size: 24),
      ),
    );
  }
}

class DBottomNavBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const DBottomNavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
