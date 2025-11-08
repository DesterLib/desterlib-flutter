import 'package:flutter/material.dart';
import 'settings_item.dart';

class DSettingsGroup extends StatelessWidget {
  final String title;
  final List<DSettingsItem> items;
  final EdgeInsetsGeometry? padding;

  const DSettingsGroup({
    super.key,
    required this.title,
    required this.items,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: padding?.resolve(TextDirection.ltr).left ?? 16,
            right: padding?.resolve(TextDirection.ltr).right ?? 16,
            top: padding?.resolve(TextDirection.ltr).top ?? 0,
            bottom: 8,
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.5,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        
        Container(
          margin: EdgeInsets.only(
            left: padding?.resolve(TextDirection.ltr).left ?? 16,
            right: padding?.resolve(TextDirection.ltr).right ?? 16,
            bottom: padding?.resolve(TextDirection.ltr).bottom ?? 0,
          ),
          decoration: ShapeDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildItemWithBorderRadius(items[i], i, items.length),
                if (i < items.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemWithBorderRadius(DSettingsItem item, int index, int totalItems) {
    BorderRadius borderRadius;
    
    if (totalItems == 1) {
      borderRadius = BorderRadius.circular(15);
    } else if (index == 0) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      );
    } else if (index == totalItems - 1) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      );
    } else {
      borderRadius = BorderRadius.zero;
    }

    return DSettingsItem(
      title: item.title,
      subtitle: item.subtitle,
      icon: item.icon,
      trailing: item.trailing,
      onTap: item.onTap,
      enabled: item.enabled,
      isActive: item.isActive,
      borderRadius: borderRadius,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
