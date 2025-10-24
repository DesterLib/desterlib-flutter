import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/shared/providers/drawer_provider.dart';
import '../widgets/settings_layout.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_item.dart';
import '../../data/tmdb_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTmdbConfigured = ref.watch(isTmdbConfiguredProvider);
    
    return AnimatedAppBarPage(
      title: 'Settings',
      maxWidthConstraint: 1220,
      child: DSettingsLayout(
        groups: [
          // Library Management Settings
          DSettingsGroup(
            title: 'Library Management',
            items: [
              DSettingsItem(
                title: 'TMDB API Key',
                subtitle: isTmdbConfigured ? 'Configured ✓' : 'Required for adding library items',
                icon: PlatformIcons.key,
                trailing: Icon(PlatformIcons.chevronRight, size: 20, color: Colors.white70),
                onTap: () {
                  ref.read(drawerProvider.notifier).openDrawer(DrawerContentType.tmdbApiKey);
                },
              ),
              DSettingsItem(
                title: 'Add Library Item',
                subtitle: isTmdbConfigured ? 'Add new movies or TV shows' : 'Requires TMDB API Key',
                icon: PlatformIcons.add,
                trailing: Icon(PlatformIcons.chevronRight, size: 20, color: Colors.white70),
                onTap: isTmdbConfigured ? () {
                  ref.read(drawerProvider.notifier).openDrawer(DrawerContentType.addLibraryItem);
                } : () {
                  ref.read(drawerProvider.notifier).openDrawer(DrawerContentType.tmdbRequired);
                },
              ),
              DSettingsItem(
                title: 'Update Library',
                subtitle: 'Refresh library metadata',
                icon: PlatformIcons.refresh,
                trailing: Icon(PlatformIcons.chevronRight, size: 20, color: Colors.white70),
                onTap: () {
                  ref.read(drawerProvider.notifier).openDrawer(DrawerContentType.updateLibrary);
                },
              ),
              DSettingsItem(
                title: 'Delete Library Item',
                subtitle: 'Remove items from library',
                icon: PlatformIcons.delete,
                trailing: Icon(PlatformIcons.chevronRight, size: 20, color: Colors.white70),
                onTap: () {
                  ref.read(drawerProvider.notifier).openDrawer(DrawerContentType.deleteLibraryItem);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
