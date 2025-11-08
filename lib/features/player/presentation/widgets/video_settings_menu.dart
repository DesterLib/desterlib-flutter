import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Shows platform-native video settings menu
void showVideoSettingsMenu(
  BuildContext context, {
  required double playbackSpeed,
  required double volume,
  required ValueChanged<double> onPlaybackSpeedChanged,
  required ValueChanged<double> onVolumeChanged,
}) {
  if (Platform.isIOS || Platform.isMacOS) {
    _showCupertinoSettings(
      context,
      playbackSpeed: playbackSpeed,
      volume: volume,
      onPlaybackSpeedChanged: onPlaybackSpeedChanged,
      onVolumeChanged: onVolumeChanged,
    );
  } else {
    _showMaterialSettings(
      context,
      playbackSpeed: playbackSpeed,
      volume: volume,
      onPlaybackSpeedChanged: onPlaybackSpeedChanged,
      onVolumeChanged: onVolumeChanged,
    );
  }
}

/// Shows iOS/macOS-style action sheet for settings
void _showCupertinoSettings(
  BuildContext context, {
  required double playbackSpeed,
  required double volume,
  required ValueChanged<double> onPlaybackSpeedChanged,
  required ValueChanged<double> onVolumeChanged,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => Theme(
      data: ThemeData.dark().copyWith(
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.dark,
        ),
      ),
      child: CupertinoActionSheet(
        title: const Text('Playback Settings'),
        actions: [
          // Playback Speed Section
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showPlaybackSpeedPicker(
                context,
                currentSpeed: playbackSpeed,
                onSpeedChanged: onPlaybackSpeedChanged,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Playback Speed',
                  style: TextStyle(color: CupertinoColors.label),
                ),
                Text(
                  '${playbackSpeed}x',
                  style: const TextStyle(color: CupertinoColors.secondaryLabel),
                ),
              ],
            ),
          ),
          // Volume Section
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showVolumePicker(
                context,
                currentVolume: volume,
                onVolumeChanged: onVolumeChanged,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Volume',
                  style: TextStyle(color: CupertinoColors.label),
                ),
                Text(
                  '${(volume * 100).round()}%',
                  style: const TextStyle(color: CupertinoColors.secondaryLabel),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text('Done'),
        ),
      ),
    ),
  );
}

/// Shows Material Design bottom sheet for settings
void _showMaterialSettings(
  BuildContext context, {
  required double playbackSpeed,
  required double volume,
  required ValueChanged<double> onPlaybackSpeedChanged,
  required ValueChanged<double> onVolumeChanged,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1C1C1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        canvasColor: const Color(0xFF1C1C1E),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Playback Settings',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFFFFFFFF)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24),
            // Playback Speed
            ListTile(
              leading: const Icon(Icons.speed, color: Color(0xFFFFFFFF)),
              title: const Text(
                'Playback Speed',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
              ),
              trailing: Text(
                '${playbackSpeed}x',
                style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                _showPlaybackSpeedPicker(
                  context,
                  currentSpeed: playbackSpeed,
                  onSpeedChanged: onPlaybackSpeedChanged,
                );
              },
            ),
            // Volume
            ListTile(
              leading: const Icon(Icons.volume_up, color: Color(0xFFFFFFFF)),
              title: const Text(
                'Volume',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
              ),
              trailing: Text(
                '${(volume * 100).round()}%',
                style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                _showVolumePicker(
                  context,
                  currentVolume: volume,
                  onVolumeChanged: onVolumeChanged,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

/// Shows playback speed picker
void _showPlaybackSpeedPicker(
  BuildContext context, {
  required double currentSpeed,
  required ValueChanged<double> onSpeedChanged,
}) {
  final speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  if (Platform.isIOS || Platform.isMacOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark().copyWith(
          cupertinoOverrideTheme: const CupertinoThemeData(
            brightness: Brightness.dark,
          ),
        ),
        child: CupertinoActionSheet(
          title: const Text('Playback Speed'),
          actions: speeds.map((speed) {
            return CupertinoActionSheetAction(
              onPressed: () {
                onSpeedChanged(speed);
                Navigator.pop(context);
              },
              isDefaultAction: speed == currentSpeed,
              child: Text('${speed}x'),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      ),
    );
  } else {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Theme(
        data: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1C1C1E),
          canvasColor: const Color(0xFF1C1C1E),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Playback Speed',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.white24),
              ...speeds.map((speed) {
                return ListTile(
                  title: Text(
                    '${speed}x',
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                    ),
                  ),
                  trailing: speed == currentSpeed
                      ? const Icon(Icons.check, color: Color(0xFF0A84FF))
                      : null,
                  onTap: () {
                    onSpeedChanged(speed);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows volume picker
void _showVolumePicker(
  BuildContext context, {
  required double currentVolume,
  required ValueChanged<double> onVolumeChanged,
}) {
  if (Platform.isIOS || Platform.isMacOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark().copyWith(
          cupertinoOverrideTheme: const CupertinoThemeData(
            brightness: Brightness.dark,
          ),
        ),
        child: CupertinoAlertDialog(
          title: const Text('Volume'),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text('${(currentVolume * 100).round()}%'),
                CupertinoSlider(
                  value: currentVolume,
                  onChanged: (value) {
                    setState(() {
                      onVolumeChanged(value);
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  } else {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Theme(
        data: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1C1C1E),
          canvasColor: const Color(0xFF1C1C1E),
        ),
        child: SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Volume',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.white24),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '${(currentVolume * 100).round()}%',
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Slider(
                        value: currentVolume,
                        onChanged: (value) {
                          setState(() {
                            onVolumeChanged(value);
                          });
                        },
                        activeColor: const Color(0xFF0A84FF),
                        inactiveColor: Colors.white24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
