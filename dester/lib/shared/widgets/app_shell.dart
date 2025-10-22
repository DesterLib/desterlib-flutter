import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'keyboard_shortcuts_dialog.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final GlobalKey<_DesktopTopNavigationState> _desktopNavKey = GlobalKey();
  final GlobalKey<_MobileBottomNavigationState> _mobileNavKey = GlobalKey();
  final FocusScopeNode _contentFocusScopeNode = FocusScopeNode();
  bool _isInNavigation = true;

  @override
  void initState() {
    super.initState();
    // Listen to content focus changes
    _contentFocusScopeNode.addListener(_onContentFocusChange);
  }

  @override
  void dispose() {
    _contentFocusScopeNode.removeListener(_onContentFocusChange);
    _contentFocusScopeNode.dispose();
    super.dispose();
  }

  void _onContentFocusChange() {
    // If content scope has a focused child, we're in content area
    if (_contentFocusScopeNode.hasFocus ||
        _contentFocusScopeNode.focusedChild != null) {
      if (_isInNavigation) {
        setState(() => _isInNavigation = false);
      }
    }
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }

  void _navigateToIndex(int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/library');
      case 2:
        context.go('/settings');
    }
  }

  void _focusNavigation() {
    // Try to focus the first navigation item
    setState(() => _isInNavigation = true);
    _desktopNavKey.currentState?.focusFirstItem();
    _mobileNavKey.currentState?.focusFirstItem();
  }

  void _focusContent() {
    // Focus the first focusable widget in the content area
    setState(() => _isInNavigation = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Request focus on the content scope, which will auto-focus the first autofocus widget
        _contentFocusScopeNode.requestFocus();
      }
    });
  }

  KeyEventResult _handleGlobalKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      // Escape key focuses navigation (essential for TV)
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _focusNavigation();
        return KeyEventResult.handled;
      }
      // Up arrow from content goes to navigation
      if (event.logicalKey == LogicalKeyboardKey.arrowUp && !_isInNavigation) {
        _focusNavigation();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _getSelectedIndex(location);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    // Use Column instead of Scaffold's appBar/bottomNavigationBar
    // This ensures navigation is part of the focus tree
    return Focus(
      onKeyEvent: _handleGlobalKey,
      child: Scaffold(
        body: Column(
          children: [
            if (isDesktop)
              _DesktopTopNavigation(
                key: _desktopNavKey,
                selectedIndex: selectedIndex,
                onDestinationSelected: _navigateToIndex,
                onNavigateDown: _focusContent,
                onFocusChanged: (hasFocus) {
                  if (hasFocus) setState(() => _isInNavigation = true);
                },
              ),
            Expanded(
              child: FocusScope(
                node: _contentFocusScopeNode,
                child: widget.child,
              ),
            ),
            if (!isDesktop)
              _MobileBottomNavigation(
                key: _mobileNavKey,
                selectedIndex: selectedIndex,
                onDestinationSelected: _navigateToIndex,
                onNavigateUp: _focusContent,
                onFocusChanged: (hasFocus) {
                  if (hasFocus) setState(() => _isInNavigation = true);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onNavigateUp;
  final ValueChanged<bool> onFocusChanged;

  const _MobileBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onNavigateUp,
    required this.onFocusChanged,
  });

  @override
  State<_MobileBottomNavigation> createState() =>
      _MobileBottomNavigationState();
}

class _MobileBottomNavigationState extends State<_MobileBottomNavigation> {
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Auto-focus the first navigation item for TV/keyboard navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes[0].canRequestFocus) {
        _focusNodes[0].requestFocus();
      }
    });
    // Listen to focus changes
    for (var node in _focusNodes) {
      node.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    final hasFocus = _focusNodes.any((node) => node.hasFocus);
    widget.onFocusChanged(hasFocus);
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.removeListener(_onFocusChange);
      node.dispose();
    }
    super.dispose();
  }

  void focusFirstItem() {
    if (mounted && _focusNodes[0].canRequestFocus) {
      _focusNodes[0].requestFocus();
    }
  }

  void _handleKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (index > 0) {
          _focusNodes[index - 1].requestFocus();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (index < 2) {
          _focusNodes[index + 1].requestFocus();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        widget.onNavigateUp();
      } else if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onDestinationSelected(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
              ),
              _buildNavButton(
                context: context,
                index: 1,
                icon: Icons.video_library_outlined,
                selectedIcon: Icons.video_library,
                label: 'Library',
              ),
              _buildNavButton(
                context: context,
                index: 2,
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = widget.selectedIndex == index;

    return Expanded(
      child: Focus(
        focusNode: _focusNodes[index],
        onKeyEvent: (node, event) {
          _handleKeyEvent(event, index);
          return KeyEventResult.handled;
        },
        child: Builder(
          builder: (context) {
            final isFocused = Focus.of(context).hasFocus;
            return InkWell(
              onTap: () => widget.onDestinationSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: isFocused
                      ? Border.all(color: colorScheme.primary, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? selectedIcon : icon,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DesktopTopNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onNavigateDown;
  final ValueChanged<bool> onFocusChanged;

  const _DesktopTopNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onNavigateDown,
    required this.onFocusChanged,
  });

  @override
  State<_DesktopTopNavigation> createState() => _DesktopTopNavigationState();
}

class _DesktopTopNavigationState extends State<_DesktopTopNavigation> {
  int _focusedIndex = 0;
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _focusedIndex = widget.selectedIndex;
    // Auto-focus the first navigation item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes[0].canRequestFocus) {
        _focusNodes[0].requestFocus();
      }
    });
    // Listen to focus changes
    for (var node in _focusNodes) {
      node.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    final hasFocus = _focusNodes.any((node) => node.hasFocus);
    widget.onFocusChanged(hasFocus);
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.removeListener(_onFocusChange);
      node.dispose();
    }
    super.dispose();
  }

  void focusFirstItem() {
    if (mounted && _focusNodes[0].canRequestFocus) {
      _focusNodes[0].requestFocus();
    }
  }

  void _handleKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (index > 0) {
          _focusNodes[index - 1].requestFocus();
          setState(() => _focusedIndex = index - 1);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (index < 2) {
          _focusNodes[index + 1].requestFocus();
          setState(() => _focusedIndex = index + 1);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        widget.onNavigateDown();
      } else if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onDestinationSelected(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // App Title/Logo
            Text(
              'Dester',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 48),
            // Navigation Items
            _NavItem(
              focusNode: _focusNodes[0],
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Home',
              selected: widget.selectedIndex == 0,
              focused: _focusedIndex == 0,
              onTap: () => widget.onDestinationSelected(0),
              onKeyEvent: (event) => _handleKeyEvent(event, 0),
            ),
            const SizedBox(width: 8),
            _NavItem(
              focusNode: _focusNodes[1],
              icon: Icons.video_library_outlined,
              selectedIcon: Icons.video_library,
              label: 'Library',
              selected: widget.selectedIndex == 1,
              focused: _focusedIndex == 1,
              onTap: () => widget.onDestinationSelected(1),
              onKeyEvent: (event) => _handleKeyEvent(event, 1),
            ),
            const SizedBox(width: 8),
            _NavItem(
              focusNode: _focusNodes[2],
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              label: 'Settings',
              selected: widget.selectedIndex == 2,
              focused: _focusedIndex == 2,
              onTap: () => widget.onDestinationSelected(2),
              onKeyEvent: (event) => _handleKeyEvent(event, 2),
            ),
            const Spacer(),
            const KeyboardShortcutHint(),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final FocusNode focusNode;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final bool focused;
  final VoidCallback onTap;
  final Function(KeyEvent) onKeyEvent;

  const _NavItem({
    required this.focusNode,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.focused,
    required this.onTap,
    required this.onKeyEvent,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (focused) {
        setState(() => _isFocused = focused);
      },
      onKeyEvent: (node, event) {
        widget.onKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.selected
                  ? colorScheme.secondaryContainer.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: _isFocused
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.selected ? widget.selectedIcon : widget.icon,
                  color: widget.selected
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: widget.selected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
