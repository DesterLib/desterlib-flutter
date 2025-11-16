import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/button_group.dart';
import 'package:dester/shared/widgets/ui/sidebar/sidebar.dart';
import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/scrollable_list.dart';
import 'package:dester/shared/widgets/ui/grid.dart';
import 'package:dester/shared/widgets/ui/bottom_nav_bar.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/features/settings/presentation/widgets/settings_item.dart';
import 'package:dester/features/settings/presentation/widgets/settings_group.dart';
import 'package:dester/features/settings/presentation/widgets/settings_layout.dart';

void main() => runApp(StorybookApp());

class StorybookApp extends StatelessWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      stories: [
        // Primary Buttons
        Story(
          name: 'Button / Primary / Label Only',
          builder: (_) => const DButton(label: 'Accept Free Trial'),
        ),
        Story(
          name: 'Button / Primary / Icon Only',
          builder: (_) => DButton(leftIcon: PlatformIcons.playArrow),
        ),
        Story(
          name: 'Button / Primary / Icon and Label',
          builder: (_) =>
              DButton(label: 'Continue', leftIcon: PlatformIcons.arrowForward),
        ),
        Story(
          name: 'Button / Primary / Full Width',
          builder: (_) =>
              const DButton(label: 'Full Width Button', fullWidth: true),
        ),
        Story(
          name: 'Button / Primary / Full Width with Icon',
          builder: (_) => DButton(
            label: 'Play Video',
            leftIcon: PlatformIcons.playArrow,
            fullWidth: true,
          ),
        ),

        // Secondary Buttons
        Story(
          name: 'Button / Secondary / Label Only',
          builder: (_) =>
              const DButton(label: 'Cancel', variant: DButtonVariant.secondary),
        ),
        Story(
          name: 'Button / Secondary / Icon Only',
          builder: (_) => DButton(
            leftIcon: PlatformIcons.close,
            variant: DButtonVariant.secondary,
          ),
        ),
        Story(
          name: 'Button / Secondary / Icon and Label',
          builder: (_) => DButton(
            label: 'Settings',
            leftIcon: PlatformIcons.settings,
            variant: DButtonVariant.secondary,
          ),
        ),
        Story(
          name: 'Button / Secondary / Full Width',
          builder: (_) => const DButton(
            label: 'Secondary Full Width',
            variant: DButtonVariant.secondary,
            fullWidth: true,
          ),
        ),
        Story(
          name: 'Button / Secondary / Full Width with Icon',
          builder: (_) => DButton(
            label: 'More Options',
            leftIcon: PlatformIcons.moreHoriz,
            variant: DButtonVariant.secondary,
            fullWidth: true,
          ),
        ),

        // Button Group
        Story(
          name: 'Button Group / Primary',
          builder: (_) => const DButtonGroup(
            buttons: [
              DButton(label: 'Option 1'),
              DButton(label: 'Option 2'),
              DButton(label: 'Option 3'),
            ],
          ),
        ),
        Story(
          name: 'Button Group / Secondary',
          builder: (_) => const DButtonGroup(
            buttons: [
              DButton(label: 'Cancel', variant: DButtonVariant.secondary),
              DButton(label: 'Back', variant: DButtonVariant.secondary),
              DButton(label: 'Skip', variant: DButtonVariant.secondary),
            ],
          ),
        ),
        Story(
          name: 'Button Group / Mixed Variants',
          builder: (_) => const DButtonGroup(
            buttons: [
              DButton(label: 'Cancel', variant: DButtonVariant.secondary),
              DButton(label: 'Continue'),
            ],
          ),
        ),

        // Sidebar
        Story(
          name: 'Sidebar',
          builder: (_) => DSidebar(
            currentIndex: 0,
            items: [
              DSidebarNavigationItem(
                label: 'Home',
                icon: PlatformIcons.home,
                onTap: () {},
              ),
              DSidebarNavigationItem(
                label: 'Library',
                icon: PlatformIcons.videoLibrary,
                onTap: () {},
              ),
              DSidebarNavigationItem(
                label: 'Settings',
                icon: PlatformIcons.settings,
                onTap: () {},
              ),
            ],
          ),
        ),

        // Card
        Story(
          name: 'Card',
          builder: (_) => const DCard(
            title: 'The Dark Knight',
            year: '2008',
            width: 300,
            height: 180,
          ),
        ),

        // Scrollable List
        Story(
          name: 'Scrollable List / Horizontal',
          builder: (_) => const DScrollableList(
            items: [
              DCardData(title: 'The Dark Knight', year: '2008'),
              DCardData(title: 'Inception', year: '2010'),
              DCardData(title: 'Interstellar', year: '2014'),
              DCardData(title: 'The Prestige', year: '2006'),
              DCardData(title: 'Memento', year: '2000'),
              DCardData(title: 'Dunkirk', year: '2017'),
              DCardData(title: 'Tenet', year: '2020'),
            ],
          ),
        ),

        // Grid
        Story(
          name: 'Grid',
          builder: (_) => const DGrid(
            items: [
              DCardData(title: 'The Dark Knight', year: '2008'),
              DCardData(title: 'Inception', year: '2010'),
              DCardData(title: 'Interstellar', year: '2014'),
              DCardData(title: 'The Prestige', year: '2006'),
              DCardData(title: 'Memento', year: '2000'),
              DCardData(title: 'Dunkirk', year: '2017'),
              DCardData(title: 'Tenet', year: '2020'),
              DCardData(title: 'The Batman', year: '2022'),
              DCardData(title: 'Oppenheimer', year: '2023'),
              DCardData(title: 'Batman Begins', year: '2005'),
              DCardData(title: 'Insomnia', year: '2002'),
              DCardData(title: 'Following', year: '1998'),
            ],
          ),
        ),

        // Bottom Navigation Bar
        Story(
          name: 'Bottom Navigation Bar',
          builder: (_) => _BottomNavBarStory(),
        ),

        // Settings Item
        Story(
          name: 'Settings Item / Basic',
          builder: (_) => DSettingsItem(
            title: 'Appearance',
            subtitle: 'Choose your preferred theme',
            icon: PlatformIcons.palette,
            trailing: Icon(
              PlatformIcons.chevronRight,
              size: 20,
              color: Colors.white70,
            ),
          ),
        ),
        Story(
          name: 'Settings Item / With Switch',
          builder: (_) => DSettingsItem(
            title: 'Auto-play',
            subtitle: 'Play next episode automatically',
            icon: PlatformIcons.playCircle,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF00FFB3),
            ),
          ),
        ),
        Story(
          name: 'Settings Item / Disabled',
          builder: (_) => DSettingsItem(
            title: 'Premium Feature',
            subtitle: 'Available with Premium subscription',
            icon: PlatformIcons.starOutlined,
            enabled: false,
          ),
        ),
        Story(
          name: 'Settings Item / No Icon',
          builder: (_) => DSettingsItem(
            title: 'Sign Out',
            trailing: Icon(Icons.logout, size: 20, color: Colors.white70),
          ),
        ),

        // Settings Group
        Story(
          name: 'Settings Group / Single Item',
          builder: (_) => DSettingsGroup(
            title: 'General',
            items: [
              DSettingsItem(
                title: 'Language',
                subtitle: 'English (US)',
                icon: PlatformIcons.language,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        Story(
          name: 'Settings Group / Multiple Items',
          builder: (_) => DSettingsGroup(
            title: 'Media',
            items: [
              DSettingsItem(
                title: 'Video Quality',
                subtitle: 'Auto (Recommended)',
                icon: PlatformIcons.videoSettings,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
              ),
              DSettingsItem(
                title: 'Auto-play',
                subtitle: 'Play next episode automatically',
                icon: PlatformIcons.playCircle,
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF00FFB3),
                ),
              ),
              DSettingsItem(
                title: 'Download Location',
                subtitle: '~/Downloads',
                icon: PlatformIcons.folder,
                trailing: Icon(
                  PlatformIcons.chevronRight,
                  size: 20,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Settings Layout
        Story(
          name: 'Settings Layout / Complete',
          builder: (_) => DSettingsLayout(
            groups: [
              DSettingsGroup(
                title: 'General',
                items: [
                  DSettingsItem(
                    title: 'Appearance',
                    subtitle: 'Choose your preferred theme',
                    icon: PlatformIcons.palette,
                    trailing: Icon(
                      PlatformIcons.chevronRight,
                      size: 20,
                      color: Colors.white70,
                    ),
                  ),
                  DSettingsItem(
                    title: 'Language',
                    subtitle: 'English (US)',
                    icon: Icons.language_outlined,
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              DSettingsGroup(
                title: 'Media',
                items: [
                  DSettingsItem(
                    title: 'Video Quality',
                    subtitle: 'Auto (Recommended)',
                    icon: Icons.video_settings_outlined,
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.white70,
                    ),
                  ),
                  DSettingsItem(
                    title: 'Auto-play',
                    subtitle: 'Play next episode automatically',
                    icon: PlatformIcons.playCircle,
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF00FFB3),
                    ),
                  ),
                ],
              ),
              DSettingsGroup(
                title: 'Account',
                items: [
                  DSettingsItem(
                    title: 'Profile',
                    subtitle: 'Manage your profile information',
                    icon: PlatformIcons.person,
                    trailing: Icon(
                      PlatformIcons.chevronRight,
                      size: 20,
                      color: Colors.white70,
                    ),
                  ),
                  DSettingsItem(title: 'Sign Out', icon: PlatformIcons.logout),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNavBarStory extends StatefulWidget {
  const _BottomNavBarStory();

  @override
  State<_BottomNavBarStory> createState() => _BottomNavBarStoryState();
}

class _BottomNavBarStoryState extends State<_BottomNavBarStory> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Selected: ${_currentIndex == 0
              ? "Home"
              : _currentIndex == 1
              ? "Library"
              : "Settings"}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: DBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          DBottomNavBarItem(
            icon: PlatformIcons.home,
            selectedIcon: PlatformIcons.home,
            label: 'Home',
          ),
          DBottomNavBarItem(
            icon: PlatformIcons.videoLibrary,
            selectedIcon: PlatformIcons.videoLibrary,
            label: 'Library',
          ),
          DBottomNavBarItem(
            icon: PlatformIcons.settings,
            selectedIcon: PlatformIcons.settings,
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
