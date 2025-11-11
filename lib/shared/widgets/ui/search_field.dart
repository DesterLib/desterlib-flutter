import 'package:flutter/material.dart';
import 'package:dester/shared/utils/platform_icons.dart';

class DSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool readOnly;
  final bool showClearButton;
  final String searchQuery;

  const DSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Search...',
    this.onChanged,
    this.onTap,
    this.onClear,
    this.readOnly = false,
    this.showClearButton = true,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: -0.5,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16,
            letterSpacing: -0.5,
          ),
          prefixIcon: Icon(
            PlatformIcons.search,
            color: Colors.grey.shade400,
            size: 20,
          ),
          suffixIcon: showClearButton && searchQuery.isNotEmpty && !readOnly
              ? IconButton(
                  icon: Icon(
                    PlatformIcons.close,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
