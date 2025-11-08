import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'player_overlay_base.dart';

/// Track option model
class TrackOption {
  final String id;
  final String label;

  const TrackOption({required this.id, required this.label});
}

/// Netflix-style overlay for selecting audio and subtitle tracks
class TracksSelectorOverlay extends StatefulWidget {
  final List<TrackOption> audioTracks;
  final List<TrackOption> subtitleTracks;
  final String selectedAudioId;
  final String selectedSubtitleId;
  final ValueChanged<String> onAudioChanged;
  final ValueChanged<String> onSubtitleChanged;
  final VoidCallback onClose;

  const TracksSelectorOverlay({
    super.key,
    required this.audioTracks,
    required this.subtitleTracks,
    required this.selectedAudioId,
    required this.selectedSubtitleId,
    required this.onAudioChanged,
    required this.onSubtitleChanged,
    required this.onClose,
  });

  @override
  State<TracksSelectorOverlay> createState() => _TracksSelectorOverlayState();
}

class _TracksSelectorOverlayState extends State<TracksSelectorOverlay> {
  final GlobalKey<BaseOverlayState> _overlayKey = GlobalKey();
  late String _selectedAudioId;
  late String _selectedSubtitleId;

  @override
  void initState() {
    super.initState();
    _selectedAudioId = widget.selectedAudioId;
    _selectedSubtitleId = widget.selectedSubtitleId;
  }

  void _handleApply() {
    widget.onAudioChanged(_selectedAudioId);
    widget.onSubtitleChanged(_selectedSubtitleId);
    _overlayKey.currentState?.animateClose();
  }

  void _handleCancel() {
    _overlayKey.currentState?.animateClose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return BaseOverlay(
      key: _overlayKey,
      onClose: widget.onClose,
      child: GestureDetector(
        onTap: () {}, // Prevent closing when tapping inside
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 800 : double.infinity,
              maxHeight: isDesktop ? 600 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Content area with split lists
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Audio section
                        Expanded(
                          child: _TrackList(
                            title: 'Audio',
                            tracks: widget.audioTracks,
                            selectedId: _selectedAudioId,
                            onSelect: (id) {
                              setState(() => _selectedAudioId = id);
                            },
                          ),
                        ),
                        // Divider
                        Container(
                          width: 1,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        // Subtitles section
                        Expanded(
                          child: _TrackList(
                            title: 'Subtitles',
                            tracks: widget.subtitleTracks,
                            selectedId: _selectedSubtitleId,
                            onSelect: (id) {
                              setState(() => _selectedSubtitleId = id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DButton(
                          label: 'Close',
                          variant: DButtonVariant.secondary,
                          size: DButtonSize.sm,
                          onTap: _handleCancel,
                        ),
                        AppSpacing.gapHorizontalMD,
                        DButton(
                          label: 'Apply',
                          variant: DButtonVariant.primary,
                          size: DButtonSize.sm,
                          onTap: _handleApply,
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
    );
  }
}

/// Track list section
class _TrackList extends StatelessWidget {
  final String title;
  final List<TrackOption> tracks;
  final String selectedId;
  final ValueChanged<String> onSelect;

  const _TrackList({
    required this.title,
    required this.tracks,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Scrollable list
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              final isSelected = track.id == selectedId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onSelect(track.id),
                  borderRadius: AppRadius.radiusMD,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: AppRadius.radiusMD,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            track.label,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0x99FFFFFF),
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_rounded,
                            color: Color(0xFFFFFFFF),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
