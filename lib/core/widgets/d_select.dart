// External packages
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_icon.dart';

class DSelect<T> extends StatelessWidget {
  final String name;
  final List<DropdownMenuItem<T>> items;
  final String? label;
  final String? hintText;
  final String? helperText;
  final T? initialValue;
  final String? Function(T?)? validator;
  final bool enabled;
  final DIconName? leadingIcon;
  final ValueChanged<T?>? onChanged;

  const DSelect({
    super.key,
    required this.name,
    required this.items,
    this.label,
    this.hintText,
    this.helperText,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.leadingIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelLarge(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          AppConstants.spacingY(AppConstants.spacingXs),
        ],
        FormBuilderField<T>(
          name: name,
          initialValue: initialValue,
          validator: validator,
          enabled: enabled,
          onChanged: onChanged,
          builder: (FormFieldState<T> field) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return _DSelectTrigger<T>(
                  field: field,
                  items: items,
                  enabled: enabled,
                  hintText: hintText,
                  helperText: helperText,
                  leadingIcon: leadingIcon,
                  minWidth: constraints.maxWidth,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _DSelectTrigger<T> extends StatefulWidget {
  final FormFieldState<T> field;
  final List<DropdownMenuItem<T>> items;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final DIconName? leadingIcon;
  final double minWidth;

  const _DSelectTrigger({
    required this.field,
    required this.items,
    required this.enabled,
    this.hintText,
    this.helperText,
    this.leadingIcon,
    required this.minWidth,
  });

  @override
  State<_DSelectTrigger<T>> createState() => _DSelectTriggerState<T>();
}

class _DSelectTriggerState<T> extends State<_DSelectTrigger<T>> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showMenu() {
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    // Estimate menu height (could be improved by measuring)
    // Assuming max 5 items visible or similar
    const estimatedMenuHeight = 200.0;

    // Check if it fits below
    // If not, check if it fits above
    // If fits above, position above with 8px gap

    // Implementation strategy:
    // Calculate available space below
    final spaceBelow = screenSize.height - (position.dy + size.height + 8);
    final spaceAbove = position.dy - 8;

    bool openUpwards = false;
    if (spaceBelow < estimatedMenuHeight && spaceAbove > spaceBelow) {
      openUpwards = true;
    }

    double? top;
    double? bottom;
    double? heightConstraint;

    if (openUpwards) {
      // Open upwards
      bottom = screenSize.height - (position.dy - 8);
      heightConstraint = spaceAbove - 8; // Leave some margin
    } else {
      // Open downwards
      top = position.dy + size.height + 8;
      heightConstraint = spaceBelow - 8;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop
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
            left: position.dx,
            top: top,
            bottom: bottom,
            width: size.width,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: heightConstraint ?? 300),
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
                    child: IntrinsicHeight(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: widget.items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return _DSelectMenuItemWidget<T>(
                              item: item,
                              isFirst: index == 0,
                              onTap: () {
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                                widget.field.didChange(item.value);
                              },
                            );
                          }).toList(),
                        ),
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
  Widget build(BuildContext context) {
    final value = widget.field.value;

    // Find selected item widget
    Widget? selectedWidget;
    if (value != null) {
      final selectedItem = widget.items
          .where((item) => item.value == value)
          .firstOrNull;
      if (selectedItem != null) {
        selectedWidget = selectedItem.child;
      }
    }

    return GestureDetector(
      key: _buttonKey,
      onTap: widget.enabled ? _showMenu : null,
      child: InputDecorator(
        decoration: InputDecoration(
          helperText: widget.helperText,
          helperStyle: AppTypography.bodySmall(
            color: Colors.white.withValues(alpha: 0.5),
          ),
          hintStyle: AppTypography.bodyMedium(
            color: Colors.white.withValues(alpha: 0.3),
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacing16,
            vertical: AppConstants.spacing12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            borderSide: const BorderSide(
              color: AppConstants.dangerColor,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            borderSide: const BorderSide(
              color: AppConstants.dangerColor,
              width: 1,
            ),
          ),
          prefixIcon: widget.leadingIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.spacing16,
                    right: AppConstants.spacing8,
                  ),
                  child: DIcon(
                    icon: widget.leadingIcon!,
                    size: AppConstants.iconSizeMd,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          errorText: widget.field.errorText,
        ),
        child: Row(
          children: [
            Expanded(
              child: DefaultTextStyle(
                style: AppTypography.bodyMedium(color: Colors.white),
                child:
                    selectedWidget ??
                    Text(
                      widget.hintText ?? '',
                      style: AppTypography.bodyMedium(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: AppConstants.spacing8),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withValues(alpha: 0.5),
                size: AppConstants.iconSizeLg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DSelectMenuItemWidget<T> extends StatefulWidget {
  final DropdownMenuItem<T> item;
  final VoidCallback onTap;
  final bool isFirst;

  const _DSelectMenuItemWidget({
    required this.item,
    required this.onTap,
    required this.isFirst,
  });

  @override
  State<_DSelectMenuItemWidget<T>> createState() =>
      _DSelectMenuItemWidgetState<T>();
}

class _DSelectMenuItemWidgetState<T> extends State<_DSelectMenuItemWidget<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.item.enabled
          ? () {
              widget.item.onTap?.call();
              widget.onTap();
            }
          : null,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacing16,
            vertical: AppConstants.spacing12,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withValues(alpha: 0.05) : null,
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
            style: AppTypography.bodyMedium(
              color: widget.item.enabled
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
            ),
            child: widget.item.child,
          ),
        ),
      ),
    );
  }
}
