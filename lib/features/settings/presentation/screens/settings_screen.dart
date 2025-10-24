import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dester/shared/widgets/ui/animated_app_bar_page.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/core/providers/connection_provider.dart';
import '../widgets/settings_layout.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_item.dart';
import '../../data/tmdb_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTmdbConfigured = ref.watch(isTmdbConfiguredProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);

    return AnimatedAppBarPage(
      title: 'Settings',
      maxWidthConstraint: 1220,
      child: DSettingsLayout(
        groups: [
          // API Connection Settings
          DSettingsGroup(
            title: 'API Connection',
            items: [
              DSettingsItem(
                title: 'API Server',
                subtitle: connectionStatus == ConnectionStatus.connected
                    ? 'Connected ✓'
                    : connectionStatus == ConnectionStatus.disconnected
                    ? 'Disconnected - Tap to connect'
                    : 'Checking connection...',
                icon: connectionStatus == ConnectionStatus.connected
                    ? PlatformIcons.checkCircle
                    : PlatformIcons.errorCircle,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
                onTap: () {
                  context.push('/api-connection');
                },
              ),
            ],
          ),
          // Library Management Settings
          DSettingsGroup(
            title: 'Library Management',
            items: [
              DSettingsItem(
                title: 'TMDB API Key',
                subtitle: isTmdbConfigured
                    ? 'Configured ✓'
                    : 'Required for adding library items',
                icon: PlatformIcons.key,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
                onTap: () {
                  context.push('/drawer/tmdb-api-key');
                },
              ),
              DSettingsItem(
                title: 'Manage Libraries',
                subtitle: 'Edit or delete libraries',
                icon: PlatformIcons.settings,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
                onTap: () {
                  context.push('/settings/manage-libraries');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
