import 'package:flutter/material.dart';
import 'settings_group.dart';

class DSettingsLayout extends StatelessWidget {
  final List<DSettingsGroup> groups;
  final EdgeInsetsGeometry? padding;

  const DSettingsLayout({super.key, required this.groups, this.padding});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    // Apply desktop padding rule: left 24, right 44 (24 + 20)
    final groupPadding =
        padding ??
        (isDesktop
            ? const EdgeInsets.only(left: 24, right: 44)
            : const EdgeInsets.symmetric(horizontal: 24));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < groups.length; i++) ...[
          DSettingsGroup(
            title: groups[i].title,
            items: groups[i].items,
            padding: groupPadding,
          ),
          if (i < groups.length - 1) const SizedBox(height: 24),
        ],
      ],
    );
  }
}
