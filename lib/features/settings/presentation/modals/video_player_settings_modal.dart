import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/modals/d_modal_wrapper.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/features/player/data/video_player_settings_provider.dart';

/// Video player default settings modal
class VideoPlayerSettingsModal {
  static Future<void> show(BuildContext context, WidgetRef ref) async {
    return showDModal(
      context: context,
      title: 'Video Player Settings',
      builder: (context) => const _VideoPlayerSettingsContent(),
    );
  }
}

class _VideoPlayerSettingsContent extends ConsumerStatefulWidget {
  const _VideoPlayerSettingsContent();

  @override
  ConsumerState<_VideoPlayerSettingsContent> createState() =>
      _VideoPlayerSettingsContentState();
}

class _VideoPlayerSettingsContentState
    extends ConsumerState<_VideoPlayerSettingsContent> {
  late String _defaultAudioTrack;
  late String _defaultSubtitleTrack;
  late double _defaultPlaybackSpeed;
  late double _subtitleSize;
  late double _subtitleBackgroundOpacity;

  static const speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
  static const subtitleSizes = [12.0, 16.0, 24.0, 32.0, 48.0];

  /// Normalize subtitle size to nearest valid value
  double _normalizeSubtitleSize(double size) {
    double closest = subtitleSizes[0];
    double minDiff = (size - closest).abs();

    for (final validSize in subtitleSizes) {
      final diff = (size - validSize).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = validSize;
      }
    }

    return closest;
  }

  @override
  void initState() {
    super.initState();
    // Initialize from provider
    final settings = ref.read(videoPlayerSettingsProvider);
    _defaultAudioTrack = settings.defaultAudioTrack;
    _defaultSubtitleTrack = settings.defaultSubtitleTrack;
    _defaultPlaybackSpeed = settings.defaultPlaybackSpeed;
    _subtitleSize = _normalizeSubtitleSize(settings.subtitleSize);
    _subtitleBackgroundOpacity = settings.subtitleBackgroundOpacity;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Default Audio Track
        _SettingsSection(
          title: 'Default Audio Track',
          child: _DropdownSetting(
            value: _defaultAudioTrack,
            items: const [
              _DropdownItem(value: 'original', label: 'Original Language'),
              _DropdownItem(value: 'english', label: 'English'),
              _DropdownItem(value: 'auto', label: 'Auto (System Language)'),
            ],
            onChanged: (value) {
              setState(() => _defaultAudioTrack = value);
            },
          ),
        ),

        AppSpacing.gapVerticalLG,

        // Default Subtitle Track
        _SettingsSection(
          title: 'Default Subtitle Track',
          child: _DropdownSetting(
            value: _defaultSubtitleTrack,
            items: const [
              _DropdownItem(value: 'off', label: 'Off'),
              _DropdownItem(value: 'english', label: 'English'),
              _DropdownItem(value: 'auto', label: 'Auto (System Language)'),
            ],
            onChanged: (value) {
              setState(() => _defaultSubtitleTrack = value);
            },
          ),
        ),

        AppSpacing.gapVerticalLG,

        // Default Playback Speed
        _SettingsSection(
          title: 'Default Playback Speed',
          child: _DropdownSetting(
            value: _defaultPlaybackSpeed.toString(),
            items: speeds.map((speed) {
              return _DropdownItem(value: speed.toString(), label: '${speed}x');
            }).toList(),
            onChanged: (value) {
              setState(() => _defaultPlaybackSpeed = double.parse(value));
            },
          ),
        ),

        AppSpacing.gapVerticalLG,

        // Subtitle Appearance
        _SettingsSection(
          title: 'Subtitle Appearance',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Combined preview (scaled to simulate video player appearance)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                        alpha: _subtitleBackgroundOpacity,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Subtitle Preview',
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize:
                            _subtitleSize *
                            0.7, // Scale to approximate video player size
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        letterSpacing: 0.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapVerticalSM,

              // Info text
              Text(
                'Preview approximates actual subtitle size in video player',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVerticalLG,

              // Subtitle Size
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Size',
                    style: TextStyle(
                      color: Color(0x99FFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${_subtitleSize.toInt()}px',
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                ),
                child: Slider(
                  value: _subtitleSize,
                  min: 12.0,
                  max: 48.0,
                  divisions: 4,
                  label: '${_subtitleSize.toInt()}px',
                  onChanged: (value) {
                    // Snap to discrete values: 12, 16, 24, 32, 48
                    double snappedValue;
                    if (value <= 14) {
                      snappedValue = 12.0;
                    } else if (value <= 20) {
                      snappedValue = 16.0;
                    } else if (value <= 28) {
                      snappedValue = 24.0;
                    } else if (value <= 40) {
                      snappedValue = 32.0;
                    } else {
                      snappedValue = 48.0;
                    }
                    setState(() => _subtitleSize = snappedValue);
                  },
                ),
              ),

              AppSpacing.gapVerticalMD,

              // Background Opacity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Background Opacity',
                    style: TextStyle(
                      color: Color(0x99FFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(_subtitleBackgroundOpacity * 100).toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                ),
                child: Slider(
                  value: _subtitleBackgroundOpacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 4,
                  onChanged: (value) {
                    setState(() => _subtitleBackgroundOpacity = value);
                  },
                ),
              ),
            ],
          ),
        ),

        AppSpacing.gapVerticalXL,

        // Save button
        DButton(
          label: 'Save Settings',
          variant: DButtonVariant.primary,
          fullWidth: true,
          onTap: () async {
            try {
              await ref
                  .read(videoPlayerSettingsProvider.notifier)
                  .saveAllSettings(
                    audioTrack: _defaultAudioTrack,
                    subtitleTrack: _defaultSubtitleTrack,
                    playbackSpeed: _defaultPlaybackSpeed,
                    subtitleSize: _subtitleSize,
                    subtitleBackgroundOpacity: _subtitleBackgroundOpacity,
                  );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              // Failed to save settings
            }
          },
        ),
      ],
    );
  }
}

/// Settings section with title
class _SettingsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0x99FFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        AppSpacing.gapVerticalSM,
        child,
      ],
    );
  }
}

/// Dropdown item model
class _DropdownItem {
  final String value;
  final String label;

  const _DropdownItem({required this.value, required this.label});
}

/// Custom dropdown setting using MenuAnchor for full offset control
class _DropdownSetting extends StatefulWidget {
  final String value;
  final List<_DropdownItem> items;
  final ValueChanged<String> onChanged;

  const _DropdownSetting({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<_DropdownSetting> createState() => _DropdownSettingState();
}

class _DropdownSettingState extends State<_DropdownSetting> {
  final MenuController _menuController = MenuController();

  String get _selectedLabel {
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => widget.items.first,
    );
    return selectedItem.label;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MenuAnchor(
          controller: _menuController,
          alignmentOffset: const Offset(0, 4),
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFF1C1C1E)),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
            visualDensity: VisualDensity.standard,
            maximumSize: WidgetStateProperty.all(
              Size(constraints.maxWidth, 300),
            ),
            minimumSize: WidgetStateProperty.all(Size(constraints.maxWidth, 0)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: AppRadius.radiusMD,
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 8),
            ),
            elevation: WidgetStateProperty.all(8),
          ),
          menuChildren: widget.items.map((item) {
            final isSelected = item.value == widget.value;
            return MenuItemButton(
              onPressed: () {
                widget.onChanged(item.value);
                _menuController.close();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.white.withValues(alpha: 0.1);
                  }
                  return Colors.transparent;
                }),
                foregroundColor: WidgetStateProperty.all(
                  isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                minimumSize: WidgetStateProperty.all(
                  Size(constraints.maxWidth, 40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                ],
              ),
            );
          }).toList(),
          builder: (context, controller, child) {
            return GestureDetector(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: AppRadius.radiusMD,
                  border: Border.all(
                    color: controller.isOpen
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedLabel,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      controller.isOpen
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      color: const Color(0x99FFFFFF),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
