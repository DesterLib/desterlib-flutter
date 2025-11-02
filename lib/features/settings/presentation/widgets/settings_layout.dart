import 'package:flutter/material.dart';
import 'settings_group.dart';

class DSettingsLayout extends StatelessWidget {
  final List<DSettingsGroup> groups;
  final EdgeInsetsGeometry? padding;

  const DSettingsLayout({super.key, required this.groups, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < groups.length; i++) ...[
            groups[i],
            if (i < groups.length - 1) const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
