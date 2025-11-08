import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';

/// Video player settings overlay
class VideoSettingsOverlay extends StatelessWidget {
  final double playbackSpeed;
  final double volume;
  final ValueChanged<double> onPlaybackSpeedChanged;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onClose;

  const VideoSettingsOverlay({
    super.key,
    required this.playbackSpeed,
    required this.volume,
    required this.onPlaybackSpeedChanged,
    required this.onVolumeChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: AppRadius.radiusLG,
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Playback Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white,
                          onPressed: onClose,
                          iconSize: 20,
                        ),
                      ],
                    ),

                    AppSpacing.gapVerticalLG,

                    // Playback Speed
                    _SettingSection(
                      title: 'Playback Speed',
                      child: _PlaybackSpeedSelector(
                        currentSpeed: playbackSpeed,
                        onSpeedChanged: onPlaybackSpeedChanged,
                      ),
                    ),

                    AppSpacing.gapVerticalLG,

                    // Volume
                    _SettingSection(
                      title: 'Volume',
                      child: _VolumeSlider(
                        volume: volume,
                        onVolumeChanged: onVolumeChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Setting section widget
class _SettingSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
        AppSpacing.gapVerticalSM,
        child,
      ],
    );
  }
}

/// Playback speed selector
class _PlaybackSpeedSelector extends StatelessWidget {
  final double currentSpeed;
  final ValueChanged<double> onSpeedChanged;

  const _PlaybackSpeedSelector({
    required this.currentSpeed,
    required this.onSpeedChanged,
  });

  static const List<double> _speeds = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: _speeds.map((speed) {
        final isSelected = (currentSpeed - speed).abs() < 0.01;
        return _SpeedChip(
          speed: speed,
          isSelected: isSelected,
          onTap: () => onSpeedChanged(speed),
        );
      }).toList(),
    );
  }
}

/// Speed chip widget
class _SpeedChip extends StatelessWidget {
  final double speed;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpeedChip({
    required this.speed,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: AppRadius.radiusSM,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          '${speed}x',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Volume slider
class _VolumeSlider extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;

  const _VolumeSlider({required this.volume, required this.onVolumeChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          volume == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          color: Colors.white.withValues(alpha: 0.7),
          size: 20,
        ),
        AppSpacing.gapHorizontalMD,
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: volume,
              min: 0.0,
              max: 1.0,
              onChanged: onVolumeChanged,
            ),
          ),
        ),
        AppSpacing.gapHorizontalMD,
        SizedBox(
          width: 40,
          child: Text(
            '${(volume * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
