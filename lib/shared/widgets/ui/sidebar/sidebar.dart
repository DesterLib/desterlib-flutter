import 'dart:ui';
import 'package:dester/shared/widgets/ui/sidebar/sidebar_item.dart';
import 'package:flutter/material.dart';

class DSidebarNavigationItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const DSidebarNavigationItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class DSidebar extends StatefulWidget {
  final int currentIndex;
  final List<DSidebarNavigationItem> items;

  const DSidebar({super.key, required this.currentIndex, required this.items});

  @override
  State<DSidebar> createState() => _DSidebarState();
}

class _DSidebarState extends State<DSidebar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                controller: _scrollController,
                clipBehavior: Clip.none,
                padding: EdgeInsets.zero,
                itemCount: widget.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return DSidebarItem(
                    label: item.label,
                    icon: item.icon,
                    isActive: widget.currentIndex == index,
                    onTap: item.onTap,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
