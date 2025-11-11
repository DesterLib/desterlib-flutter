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
import '../modals/settings_modals.dart';
import '../modals/video_player_settings_modal.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTmdbConfigured = ref.watch(isTmdbConfiguredProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return AnimatedAppBarPage(
      title: 'Settings',
      useCompactHeight: isDesktop,
      maxWidthConstraint: 1220,
      leading: const SizedBox.shrink(), // Prevent automatic back button
      child: DSettingsLayout(
        groups: [
          // General Settings
          DSettingsGroup(
            title: 'General',
            items: [
              DSettingsItem(
                title: 'Video Player',
                subtitle: 'Audio, subtitles and more',
                icon: PlatformIcons.playCircle,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
                onTap: () async {
                  await VideoPlayerSettingsModal.show(context, ref);
                },
              ),
            ],
          ),
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
                onTap: () async {
                  await ApiConnectionModal.show(context, ref);
                },
              ),
            ],
          ),
          // Developer Settings
          DSettingsGroup(
            title: 'Developer',
            items: [
              DSettingsItem(
                title: 'API Logs',
                subtitle: 'View real-time server logs',
                icon: Icons.terminal,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
                onTap: () {
                  context.push('/settings/logs');
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
                onTap: () async {
                  await TmdbApiKeyModal.show(context, ref);
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
