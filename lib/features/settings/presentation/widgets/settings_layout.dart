import 'package:flutter/material.dart';
import 'settings_group.dart';

class DSettingsLayout extends StatelessWidget {
  final List<DSettingsGroup> groups;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;

  const DSettingsLayout({
    super.key,
    required this.groups,
    this.padding,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: padding ?? const EdgeInsets.all(12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < groups.length; i++) ...[
                groups[i],
                if (i < groups.length - 1) const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
