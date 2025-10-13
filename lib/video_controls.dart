import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:window_manager/window_manager.dart';

class VideoControls extends StatefulWidget {
  final VideoState state;
  final Player player;
  final String? title;
  final int? season;
  final int? episode;
  final String? episodeTitle;

  const VideoControls({
    super.key,
    required this.state,
    required this.player,
    this.title,
    this.season,
    this.episode,
    this.episodeTitle,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

enum TrackMenuType { none, audio, subtitle }

class _VideoControlsState extends State<VideoControls> with WindowListener {
  bool _controlsVisible = true;
  Timer? _hideTimer;
  bool _isDragging = false;
  double? _dragValue;
  TrackMenuType _activeMenu = TrackMenuType.none;
  bool _isFullscreen = false;
  double _volume = 100.0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    windowManager.addListener(this);
    _initializeVolume();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    windowManager.removeListener(this);
    super.dispose();
  }

  void _initializeVolume() {
    setState(() {
      _volume = widget.player.state.volume;
    });
  }

  @override
  void onWindowEnterFullScreen() {
    setState(() => _isFullscreen = true);
  }

  @override
  void onWindowLeaveFullScreen() {
    setState(() => _isFullscreen = false);
  }

  Future<void> _toggleFullscreen() async {
    if (_isFullscreen) {
      await windowManager.setFullScreen(false);
    } else {
      await windowManager.setFullScreen(true);
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        widget.player.setVolume(0);
      } else {
        widget.player.setVolume(_volume);
      }
    });
    _showControls();
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
      if (!_isMuted) {
        widget.player.setVolume(value);
      }
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_isDragging && widget.player.state.playing) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _showControls() {
    setState(() => _controlsVisible = true);
    _startHideTimer();
  }

  void _togglePlayPause() {
    widget.player.playOrPause();
    _showControls();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '$minutes:${twoDigits(seconds)}';
  }

  double get _currentSliderValue {
    if (_isDragging && _dragValue != null) {
      return _dragValue!;
    }
    return widget.player.state.position.inMilliseconds.toDouble();
  }

  bool get _isDesktop {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 768;
  }

  String? get _formattedTitle {
    if (widget.title == null) return null;

    // Check if it's a TV show (has season and episode)
    if (widget.season != null && widget.episode != null) {
      final seasonEpisode = 'S${widget.season}E${widget.episode}';
      if (widget.episodeTitle != null && widget.episodeTitle!.isNotEmpty) {
        return '${widget.title} | $seasonEpisode - ${widget.episodeTitle}';
      }
      return '${widget.title} | $seasonEpisode';
    }

    // It's a movie, just return the title
    return widget.title;
  }

  void _toggleAudioTrackMenu() {
    _hideTimer?.cancel();
    if (_isDesktop) {
      setState(() {
        _activeMenu = _activeMenu == TrackMenuType.audio
            ? TrackMenuType.none
            : TrackMenuType.audio;
      });
      if (_activeMenu == TrackMenuType.none) {
        _startHideTimer();
      }
    } else {
      _showMobileTrackDrawer(TrackMenuType.audio);
    }
  }

  void _toggleSubtitleTrackMenu() {
    _hideTimer?.cancel();
    if (_isDesktop) {
      setState(() {
        _activeMenu = _activeMenu == TrackMenuType.subtitle
            ? TrackMenuType.none
            : TrackMenuType.subtitle;
      });
      if (_activeMenu == TrackMenuType.none) {
        _startHideTimer();
      }
    } else {
      _showMobileTrackDrawer(TrackMenuType.subtitle);
    }
  }

  void _showMobileTrackDrawer(TrackMenuType menuType) {
    final title = menuType == TrackMenuType.audio
        ? 'Audio Tracks'
        : 'Subtitles';
    final tracks = menuType == TrackMenuType.audio
        ? widget.player.state.tracks.audio
        : widget.player.state.tracks.subtitle;
    final currentTrack = menuType == TrackMenuType.audio
        ? widget.player.state.track.audio
        : widget.player.state.track.subtitle;
    final isSubtitle = menuType == TrackMenuType.subtitle;
    final isAudio = menuType == TrackMenuType.audio;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24),
            // Track list
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Auto option for audio tracks
                  if (isAudio)
                    _DrawerTrackItem(
                      label: 'Auto',
                      isSelected: currentTrack.id == 'auto',
                      onTap: () {
                        widget.player.setAudioTrack(AudioTrack.auto());
                        Navigator.pop(context);
                        _startHideTimer();
                      },
                    ),
                  // Off option for subtitles
                  if (isSubtitle)
                    _DrawerTrackItem(
                      label: 'Off',
                      isSelected: currentTrack.id == 'no',
                      onTap: () {
                        widget.player.setSubtitleTrack(SubtitleTrack.no());
                        Navigator.pop(context);
                        _startHideTimer();
                      },
                    ),
                  // All available tracks (filtered)
                  ...tracks
                      .where(_isValidTrack)
                      .map(
                        (track) => _DrawerTrackItem(
                          label: _getTrackLabel(track),
                          isSelected: currentTrack.id == track.id,
                          onTap: () {
                            if (menuType == TrackMenuType.audio) {
                              widget.player.setAudioTrack(track as AudioTrack);
                            } else {
                              widget.player.setSubtitleTrack(
                                track as SubtitleTrack,
                              );
                            }
                            Navigator.pop(context);
                            _startHideTimer();
                          },
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _startHideTimer());
  }

  void _closeMenus() {
    setState(() => _activeMenu = TrackMenuType.none);
    _startHideTimer();
  }

  String _getLanguageName(String code) {
    final languageMap = {
      'en': 'English',
      'eng': 'English',
      'es': 'Spanish',
      'spa': 'Spanish',
      'fr': 'French',
      'fra': 'French',
      'fre': 'French',
      'de': 'German',
      'deu': 'German',
      'ger': 'German',
      'it': 'Italian',
      'ita': 'Italian',
      'pt': 'Portuguese',
      'por': 'Portuguese',
      'ru': 'Russian',
      'rus': 'Russian',
      'ja': 'Japanese',
      'jp': 'Japanese',
      'jpn': 'Japanese',
      'ko': 'Korean',
      'kor': 'Korean',
      'zh': 'Chinese',
      'chi': 'Chinese',
      'zho': 'Chinese',
      'ar': 'Arabic',
      'ara': 'Arabic',
      'hi': 'Hindi',
      'hin': 'Hindi',
      'nl': 'Dutch',
      'nld': 'Dutch',
      'sv': 'Swedish',
      'swe': 'Swedish',
      'no': 'Norwegian',
      'nor': 'Norwegian',
      'da': 'Danish',
      'dan': 'Danish',
      'fi': 'Finnish',
      'fin': 'Finnish',
      'pl': 'Polish',
      'pol': 'Polish',
      'tr': 'Turkish',
      'tur': 'Turkish',
      'he': 'Hebrew',
      'heb': 'Hebrew',
      'th': 'Thai',
      'tha': 'Thai',
      'vi': 'Vietnamese',
      'vie': 'Vietnamese',
      'id': 'Indonesian',
      'ind': 'Indonesian',
      'ms': 'Malay',
      'msa': 'Malay',
      'el': 'Greek',
      'ell': 'Greek',
      'gre': 'Greek',
      'cs': 'Czech',
      'ces': 'Czech',
      'cze': 'Czech',
      'hu': 'Hungarian',
      'hun': 'Hungarian',
      'ro': 'Romanian',
      'ron': 'Romanian',
      'rum': 'Romanian',
      'uk': 'Ukrainian',
      'ukr': 'Ukrainian',
    };

    final lowerCode = code.toLowerCase().trim();
    return languageMap[lowerCode] ?? code.toUpperCase();
  }

  bool _isValidTrack(dynamic track) {
    if (track == null) return false;

    final id = track.id ?? '';
    final title = track.title ?? '';
    final language = track.language ?? '';

    // Filter out auto and no tracks (handled separately)
    if (id == 'auto' || id == 'no') return false;

    // Track must have at least language or a meaningful title
    if (language.isNotEmpty) return true;
    if (title.isNotEmpty && !RegExp(r'^[\d\s]+$').hasMatch(title)) return true;

    return false;
  }

  String _getTrackLabel(dynamic track) {
    if (track == null) return 'None';

    final id = track.id ?? '';
    final title = track.title ?? '';
    final language = track.language ?? '';

    // Priority 1: Use language field and convert to readable name
    if (language.isNotEmpty) {
      return _getLanguageName(language);
    }

    // Priority 2: Check if title is a language code and convert it
    if (title.isNotEmpty && !RegExp(r'^[\d\s]+$').hasMatch(title)) {
      // If title is a short code (likely a language code), convert it
      if (title.length <= 3) {
        return _getLanguageName(title);
      }
      // If title seems like a description, use it as-is
      return title;
    }

    // Fallback to ID if it's meaningful
    if (id.isNotEmpty && id != 'auto' && id != 'no') {
      return 'Track $id';
    }

    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _showControls(),
      child: GestureDetector(
        onTap: () {
          if (_isDesktop && _activeMenu != TrackMenuType.none) {
            _closeMenus();
          } else {
            setState(() => _controlsVisible = !_controlsVisible);
            if (_controlsVisible) _startHideTimer();
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Desktop top bar with title
              if (_isDesktop && _formattedTitle != null) _buildDesktopTopBar(),

              // Platform-specific controls
              if (_isDesktop)
                _buildDesktopControls()
              else
                _buildMobileControls(),

              // Track menus (positioned above everything else - desktop only)
              if (_isDesktop &&
                  _controlsVisible &&
                  _activeMenu != TrackMenuType.none)
                _buildTrackMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileControls() {
    return Stack(
      children: [
        // Gradient backdrop (non-interactive)
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _controlsVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Top left - Back button
        Positioned(
          top: 16,
          left: 16,
          child: AnimatedOpacity(
            opacity: _controlsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_controlsVisible,
              child: SafeArea(
                child: _MobileControlButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () {
                    // Handle back navigation
                    Navigator.of(context).maybePop();
                  },
                ),
              ),
            ),
          ),
        ),

        // Top right - Settings/Options
        Positioned(
          top: 16,
          right: 16,
          child: AnimatedOpacity(
            opacity: _controlsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_controlsVisible,
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MobileControlButton(
                      icon: _isMuted
                          ? Icons.volume_off_rounded
                          : _volume > 50
                          ? Icons.volume_up_rounded
                          : Icons.volume_down_rounded,
                      onPressed: _toggleMute,
                    ),
                    const SizedBox(width: 8),
                    _MobileControlButton(
                      icon: Icons.audiotrack_rounded,
                      onPressed: _toggleAudioTrackMenu,
                    ),
                    const SizedBox(width: 8),
                    _MobileControlButton(
                      icon: Icons.closed_caption_rounded,
                      onPressed: _toggleSubtitleTrackMenu,
                    ),
                    const SizedBox(width: 8),
                    _MobileControlButton(
                      icon: _isFullscreen
                          ? Icons.fullscreen_exit_rounded
                          : Icons.fullscreen_rounded,
                      onPressed: _toggleFullscreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Center - Playback controls (YouTube style)
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _controlsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Center(
              child: IgnorePointer(
                ignoring: !_controlsVisible,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MobileControlButton(
                      icon: Icons.replay_10_rounded,
                      size: 28,
                      onPressed: () {
                        widget.player.seek(
                          widget.player.state.position -
                              const Duration(seconds: 10),
                        );
                        _showControls();
                      },
                    ),
                    const SizedBox(width: 32),
                    _MobileControlButton(
                      icon: widget.player.state.playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 36,
                      onPressed: _togglePlayPause,
                    ),
                    const SizedBox(width: 32),
                    _MobileControlButton(
                      icon: Icons.forward_10_rounded,
                      size: 28,
                      onPressed: () {
                        widget.player.seek(
                          widget.player.state.position +
                              const Duration(seconds: 10),
                        );
                        _showControls();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom area - Progress bar only
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: _controlsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_controlsVisible,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildMobileProgressBar(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _currentSliderValue.clamp(
              0.0,
              widget.player.state.duration.inMilliseconds.toDouble(),
            ),
            min: 0.0,
            max: widget.player.state.duration.inMilliseconds.toDouble(),
            onChangeStart: (value) {
              setState(() {
                _isDragging = true;
                _dragValue = value;
              });
            },
            onChanged: (value) {
              setState(() => _dragValue = value);
              widget.player.seek(Duration(milliseconds: value.toInt()));
            },
            onChangeEnd: (value) {
              setState(() {
                _isDragging = false;
                _dragValue = null;
              });
              _startHideTimer();
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(
                  Duration(milliseconds: _currentSliderValue.toInt()),
                ),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                _formatDuration(widget.player.state.duration),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: _controlsVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 768),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress bar with timestamps
                        _buildDesktopProgressBar(),
                        const SizedBox(height: 16),
                        // Controls row
                        Row(
                          children: [
                            // Left side - Playback controls
                            Row(
                              children: [
                                _DesktopControlButton(
                                  icon: widget.player.state.playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  onPressed: _togglePlayPause,
                                ),
                                const SizedBox(width: 8),
                                _DesktopControlButton(
                                  icon: Icons.replay_10_rounded,
                                  onPressed: () {
                                    widget.player.seek(
                                      widget.player.state.position -
                                          const Duration(seconds: 10),
                                    );
                                    _showControls();
                                  },
                                ),
                                const SizedBox(width: 8),
                                _DesktopControlButton(
                                  icon: Icons.forward_10_rounded,
                                  onPressed: () {
                                    widget.player.seek(
                                      widget.player.state.position +
                                          const Duration(seconds: 10),
                                    );
                                    _showControls();
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Right side - Volume, tracks, fullscreen
                            Row(
                              children: [
                                _buildDesktopVolumeControl(),
                                const SizedBox(width: 16),
                                _DesktopControlButton(
                                  icon: Icons.audiotrack_rounded,
                                  onPressed: _toggleAudioTrackMenu,
                                ),
                                const SizedBox(width: 8),
                                _DesktopControlButton(
                                  icon: Icons.closed_caption_rounded,
                                  onPressed: _toggleSubtitleTrackMenu,
                                ),
                                const SizedBox(width: 8),
                                _DesktopControlButton(
                                  icon: _isFullscreen
                                      ? Icons.fullscreen_exit_rounded
                                      : Icons.fullscreen_rounded,
                                  onPressed: _toggleFullscreen,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTopBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: AnimatedOpacity(
        opacity: _controlsVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 768),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formattedTitle!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopProgressBar() {
    return Row(
      children: [
        Text(
          _formatDuration(Duration(milliseconds: _currentSliderValue.toInt())),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _currentSliderValue.clamp(
                0.0,
                widget.player.state.duration.inMilliseconds.toDouble(),
              ),
              min: 0.0,
              max: widget.player.state.duration.inMilliseconds.toDouble(),
              onChangeStart: (value) {
                setState(() {
                  _isDragging = true;
                  _dragValue = value;
                });
              },
              onChanged: (value) {
                setState(() => _dragValue = value);
                widget.player.seek(Duration(milliseconds: value.toInt()));
              },
              onChangeEnd: (value) {
                setState(() {
                  _isDragging = false;
                  _dragValue = null;
                });
                _startHideTimer();
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          _formatDuration(widget.player.state.duration),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopVolumeControl() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DesktopControlButton(
          icon: _isMuted
              ? Icons.volume_off_rounded
              : _volume > 50
              ? Icons.volume_up_rounded
              : Icons.volume_down_rounded,
          onPressed: _toggleMute,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _isMuted ? 0 : _volume,
              min: 0.0,
              max: 100.0,
              onChanged: (value) {
                _setVolume(value);
                if (_isMuted && value > 0) {
                  setState(() => _isMuted = false);
                }
                _showControls();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackMenu() {
    final isMobile = !_isDesktop;
    final title = _activeMenu == TrackMenuType.audio
        ? 'Audio Tracks'
        : 'Subtitles';
    final tracks = _activeMenu == TrackMenuType.audio
        ? widget.player.state.tracks.audio
        : widget.player.state.tracks.subtitle;
    final currentTrack = _activeMenu == TrackMenuType.audio
        ? widget.player.state.track.audio
        : widget.player.state.track.subtitle;
    final isSubtitle = _activeMenu == TrackMenuType.subtitle;
    final isAudio = _activeMenu == TrackMenuType.audio;

    return Positioned(
      left: 0,
      right: 0,
      bottom: isMobile ? 200 : 180,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Align(
              alignment: Alignment.centerRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 280,
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        // Track list
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              // Auto option for audio tracks
                              if (isAudio)
                                _TrackMenuItem(
                                  label: 'Auto',
                                  isSelected: currentTrack.id == 'auto',
                                  onTap: () {
                                    widget.player.setAudioTrack(
                                      AudioTrack.auto(),
                                    );
                                    _closeMenus();
                                  },
                                ),
                              // Off option for subtitles
                              if (isSubtitle)
                                _TrackMenuItem(
                                  label: 'Off',
                                  isSelected: currentTrack.id == 'no',
                                  onTap: () {
                                    widget.player.setSubtitleTrack(
                                      SubtitleTrack.no(),
                                    );
                                    _closeMenus();
                                  },
                                ),
                              // All available tracks (filtered)
                              ...tracks
                                  .where(_isValidTrack)
                                  .map(
                                    (track) => _TrackMenuItem(
                                      label: _getTrackLabel(track),
                                      isSelected: currentTrack.id == track.id,
                                      onTap: () {
                                        if (_activeMenu ==
                                            TrackMenuType.audio) {
                                          widget.player.setAudioTrack(
                                            track as AudioTrack,
                                          );
                                        } else {
                                          widget.player.setSubtitleTrack(
                                            track as SubtitleTrack,
                                          );
                                        }
                                        _closeMenus();
                                      },
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _MobileControlButton({
    required this.icon,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.white.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.4),
          ),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}

class _DesktopControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _DesktopControlButton({
    required this.icon,
    required this.onPressed,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}

class _TrackMenuItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TrackMenuItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_rounded, color: Colors.white, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerTrackItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerTrackItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_rounded, color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
