// External packages
import 'package:flutter/material.dart';

// Feature
import '../../../video_player/video_player_feature.dart';

/// Example video player screen demonstrating all three platform layouts
/// This is a reference implementation showing how to use the video player controls
class ExamplePlayerScreen extends StatefulWidget {
  const ExamplePlayerScreen({super.key});

  @override
  State<ExamplePlayerScreen> createState() => _ExamplePlayerScreenState();
}

class _ExamplePlayerScreenState extends State<ExamplePlayerScreen> {
  // Player state
  bool _isPlaying = false;
  Duration _currentPosition = const Duration(seconds: 30);
  final Duration _totalDuration = const Duration(minutes: 2, seconds: 30);
  Duration _bufferedPosition = const Duration(minutes: 1);
  double _volume = 0.8;
  bool _isMuted = false;
  bool _isFullscreen = false;
  PlayerPlatform _selectedPlatform = PlayerPlatform.mobile;

  // Simulated player methods
  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _handleSeek(Duration position) {
    setState(() {
      _currentPosition = position;
    });
  }

  void _skipForward() {
    setState(() {
      _currentPosition = Duration(
        milliseconds: (_currentPosition.inMilliseconds + 15000).clamp(
          0,
          _totalDuration.inMilliseconds,
        ),
      );
    });
  }

  void _skipBackward() {
    setState(() {
      _currentPosition = Duration(
        milliseconds: (_currentPosition.inMilliseconds - 15000).clamp(
          0,
          _totalDuration.inMilliseconds,
        ),
      );
    });
  }

  void _handleVolumeChanged(double value) {
    setState(() {
      _volume = value;
      if (value > 0 && _isMuted) {
        _isMuted = false;
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  void _showAudioSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Audio settings tapped')));
  }

  void _showSubtitleSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Subtitle settings tapped')));
  }

  void _showSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings tapped')));
  }

  Widget _buildPlatformButton(
    String label,
    PlayerPlatform platform,
    IconData icon,
  ) {
    final isSelected = _selectedPlatform == platform;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlatform = platform;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video placeholder

          // Platform controls
          PlatformPlayerControls(
            isPlaying: _isPlaying,
            currentPosition: _currentPosition,
            totalDuration: _totalDuration,
            bufferedPosition: _bufferedPosition,
            volume: _volume,
            isMuted: _isMuted,
            isFullscreen: _isFullscreen,
            onPlayPause: _togglePlayPause,
            onSeek: _handleSeek,
            onSkipForward: _skipForward,
            onSkipBackward: _skipBackward,
            onVolumeChanged: _handleVolumeChanged,
            onMuteToggle: _toggleMute,
            onAudioSettings: _showAudioSettings,
            onSubtitleSettings: _showSubtitleSettings,
            onSettings: _showSettings,
            onFullscreenToggle: _toggleFullscreen,
            onBack: () => Navigator.of(context).pop(),
            forcePlatform:
                _selectedPlatform, // Force specific platform for demo
          ),

          // Platform selector buttons (for demo purposes only)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPlatformButton(
                        'Mobile',
                        PlayerPlatform.mobile,
                        Icons.phone_android,
                      ),
                      const SizedBox(width: 4),
                      _buildPlatformButton(
                        'Desktop',
                        PlayerPlatform.desktop,
                        Icons.computer,
                      ),
                      const SizedBox(width: 4),
                      _buildPlatformButton('TV', PlayerPlatform.tv, Icons.tv),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
