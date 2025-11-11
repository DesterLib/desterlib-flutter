import 'package:flutter/material.dart';
import 'settings_group.dart';

class DSettingsLayout extends StatelessWidget {
  final List<DSettingsGroup> groups;
  final EdgeInsetsGeometry? padding;

  const DSettingsLayout({super.key, required this.groups, this.padding});

  @override
  Widget build(BuildContext context) {
    // Use provided padding or default to zero (let parent handle padding)
    final groupPadding = padding ?? EdgeInsets.zero;

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
