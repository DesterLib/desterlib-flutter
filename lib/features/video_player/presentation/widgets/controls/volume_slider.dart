// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// Volume slider with mute toggle
class VolumeSlider extends StatelessWidget {
  final double volume;
  final bool isMuted;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onMuteToggle;
  final Axis direction;
  final double? width;
  final double? height;

  const VolumeSlider({
    super.key,
    required this.volume,
    required this.isMuted,
    required this.onVolumeChanged,
    required this.onMuteToggle,
    this.direction = Axis.horizontal,
    this.width,
    this.height,
  });

  DIconName _getVolumeIcon() {
    if (isMuted || volume == 0) {
      return DIconName.volumeOff;
    } else if (volume < 0.5) {
      return DIconName.volumeDown;
    } else {
      return DIconName.volumeUp;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Container(
        width: width ?? 40,
        height: height ?? 200,
        padding: AppConstants.padding(AppConstants.spacing8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onMuteToggle,
              child: DIcon(
                icon: _getVolumeIcon(),
                size: AppConstants.iconSizeMd,
                color: Colors.white,
              ),
            ),
            AppConstants.spacingY(AppConstants.spacing8),
            Expanded(
              child: RotatedBox(
                quarterTurns: -1,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                    activeTrackColor: AppConstants.accentColor,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: AppConstants.accentColor,
                  ),
                  child: Slider(
                    value: isMuted ? 0 : volume.clamp(0.0, 1.0),
                    onChanged: (value) {
                      onVolumeChanged(value);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Horizontal layout
    return Container(
      width: width ?? 150,
      padding: AppConstants.paddingX(AppConstants.spacing12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onMuteToggle,
            child: DIcon(
              icon: _getVolumeIcon(),
              size: AppConstants.iconSizeMd,
              color: Colors.white,
            ),
          ),
          AppConstants.spacingX(AppConstants.spacing8),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: AppConstants.accentColor,
                inactiveTrackColor: Colors.white.withOpacity(0.3),
                thumbColor: AppConstants.accentColor,
              ),
              child: Slider(
                value: isMuted ? 0 : volume.clamp(0.0, 1.0),
                onChanged: (value) {
                  onVolumeChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
