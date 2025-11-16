import 'dart:ui';
import 'package:dester/shared/widgets/ui/sidebar/sidebar_item.dart';
import 'package:dester/shared/widgets/ui/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/features/library/presentation/provider/library_search_provider.dart';

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

class DSidebar extends ConsumerStatefulWidget {
  final int currentIndex;
  final List<DSidebarNavigationItem> items;
  final bool showSearch;

  const DSidebar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.showSearch = false,
  });

  @override
  ConsumerState<DSidebar> createState() => _DSidebarState();
}

class _DSidebarState extends ConsumerState<DSidebar> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Listen for focus to navigate to library page
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        final currentPath = GoRouterState.of(context).uri.path;
        if (!currentPath.startsWith('/library')) {
          context.go('/library?focus=search');
        }
      }
    });
  }

  void _handleSearchChanged(String query) {
    // Update the provider with the search query
    ref.read(librarySearchProvider.notifier).setQuery(query);
  }

  void _handleClear() {
    setState(() {
      _searchController.clear();
    });
    ref.read(librarySearchProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Search field (if enabled)
                  if (widget.showSearch) ...[
                    DSearchField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      hintText: 'Search...',
                      searchQuery: _searchController.text,
                      onChanged: _handleSearchChanged,
                      onClear: _handleClear,
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Navigation items
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.zero,
                      itemCount: widget.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
