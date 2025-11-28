// Dart
import 'dart:async';
import 'dart:ui';

// External packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_icon_button.dart';

/// A custom popup menu item
class DPopupMenuItem<T> {
  final T value;
  final Widget child;
  final bool isEnabled;

  const DPopupMenuItem({
    required this.value,
    required this.child,
    this.isEnabled = true,
  });
}

/// A custom popup menu that matches the design system
/// Uses Flutter's native showMenu with custom styling
class DPopupMenu<T> extends StatefulWidget {
  /// The icon to display on the button
  final DIconName icon;

  /// Button size (sm, md)
  final DIconButtonSize size;

  /// Button variant (primary, secondary, plain)
  final DIconButtonVariant variant;

  /// List of menu items
  final List<DPopupMenuItem<T>> items;

  /// Callback when an item is selected
  final ValueChanged<T>? onSelected;

  /// Optional offset for the menu position
  final Offset? offset;

  const DPopupMenu({
    super.key,
    required this.icon,
    required this.size,
    required this.variant,
    required this.items,
    this.onSelected,
    this.offset,
  });

  @override
  State<DPopupMenu<T>> createState() => _DPopupMenuState<T>();
}

class _DPopupMenuState<T> extends State<DPopupMenu<T>> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showMenu(BuildContext context) {
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    // Estimate menu height for vertical flip calculation
    const estimatedMenuHeight = 200.0;

    // Calculate menu position - right-align menu with button
    final menuTop = position.dy + size.height + (widget.offset?.dy ?? 8);

    // Right-align: button's right edge aligns with menu's right edge
    final buttonRight = position.dx + size.width;
    final rightOffset =
        screenSize.width - buttonRight - (widget.offset?.dx ?? 0);

    double adjustedRight = rightOffset;
    double adjustedTop = menuTop;

    // Prevent horizontal overflow (right side)
    if (adjustedRight < 8) {
      adjustedRight = 8;
    }

    // Prevent vertical overflow (show above button if needed)
    if (adjustedTop + estimatedMenuHeight > screenSize.height) {
      adjustedTop =
          position.dy - estimatedMenuHeight - (widget.offset?.dy ?? 8);
      if (adjustedTop < 8) {
        adjustedTop = 8;
      }
    }

    // Calculate max width to prevent left overflow
    final maxWidth = screenSize.width - adjustedRight - 8;

    // Create overlay entry for custom popover
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop to close menu on tap
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          // Menu
          Positioned(
            right: adjustedRight,
            top: adjustedTop,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLg,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.13),
                        width: 1,
                      ),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.items
                            .where((item) => item.isEnabled)
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final item = entry.value;

                              return _DPopupMenuItemWidget<T>(
                                value: item.value,
                                isFirst: index == 0,
                                onTap: () {
                                  _overlayEntry?.remove();
                                  _overlayEntry = null;
                                  widget.onSelected?.call(item.value);
                                },
                                child: item.child,
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DIconButton(
      key: _buttonKey,
      icon: widget.icon,
      size: widget.size,
      variant: widget.variant,
      onPressed: () {
        HapticFeedback.lightImpact();
        _showMenu(context);
      },
    );
  }
}

/// Custom popup menu item widget that matches sidebar item styling
class _DPopupMenuItemWidget<T> extends PopupMenuItem<T> {
  final Widget child;
  final VoidCallback onTap;
  final bool isFirst;

  const _DPopupMenuItemWidget({
    required super.value,
    required this.child,
    required this.onTap,
    this.isFirst = false,
  }) : super(
         height: 0, // Remove default height/padding
         padding: EdgeInsets.zero, // Remove default padding
         child: const SizedBox.shrink(), // Placeholder, we override build
       );

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() =>
      _DPopupMenuItemWidgetState<T>();
}

class _DPopupMenuItemWidgetState<T>
    extends PopupMenuItemState<T, _DPopupMenuItemWidget<T>> {
  bool _isPressed = false;
  DateTime? _tapDownTime;
  Timer? _resetTimer;

  void _handleTapDown(TapDownDetails details) {
    _tapDownTime = DateTime.now();
    setState(() {
      _isPressed = true;
    });
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _resetButtonState();
  }

  void _handleTapCancel() {
    _resetButtonState();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _resetButtonState() {
    if (_tapDownTime == null) return;

    _resetTimer?.cancel();

    final tapDuration = DateTime.now().difference(_tapDownTime!);
    final minDuration = AppConstants.buttonAnimationDuration;

    if (tapDuration < minDuration) {
      _resetTimer = Timer(minDuration - tapDuration, () {
        if (mounted) {
          setState(() {
            _isPressed = false;
            _tapDownTime = null;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          _isPressed = false;
          _tapDownTime = null;
        });
      }
    }
  }

  void _handleTap() {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedOpacity(
        duration: AppConstants.buttonAnimationDuration,
        opacity: _isPressed ? 0.6 : 1.0,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 36, // Match sidebar item approximate height
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacing12,
            vertical: AppConstants.spacing8,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: widget.isFirst
                ? null
                : Border(
                    top: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
          ),
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(
              context,
            ).style.copyWith(color: Colors.white.withValues(alpha: 0.6)),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
