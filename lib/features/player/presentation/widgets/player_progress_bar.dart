import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Video player progress bar without thumb indicator
class PlayerProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Duration buffer;
  final ValueChanged<Duration> onSeek;
  final VoidCallback? onSeekStart;
  final VoidCallback? onSeekEnd;
  final bool enabled;

  const PlayerProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.buffer,
    required this.onSeek,
    this.onSeekStart,
    this.onSeekEnd,
    this.enabled = true,
  });

  @override
  State<PlayerProgressBar> createState() => _PlayerProgressBarState();
}

class _PlayerProgressBarState extends State<PlayerProgressBar> {
  double? _dragValue;
  bool _isDragging = false;

  double get _progress {
    if (widget.duration.inMilliseconds == 0) return 0.0;
    return widget.position.inMilliseconds / widget.duration.inMilliseconds;
  }

  double get _bufferProgress {
    if (widget.duration.inMilliseconds == 0) return 0.0;
    return widget.buffer.inMilliseconds / widget.duration.inMilliseconds;
  }

  Duration _getDurationFromValue(double value) {
    final milliseconds = (value * widget.duration.inMilliseconds).round();
    return Duration(milliseconds: milliseconds);
  }

  @override
  Widget build(BuildContext context) {
    final displayProgress = _dragValue ?? _progress;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: widget.enabled
          ? (details) {
              HapticFeedback.mediumImpact();
              widget.onSeekStart?.call();
              setState(() {
                _isDragging = true;
                _dragValue = _progress;
              });
            }
          : null,
      onHorizontalDragUpdate: widget.enabled
          ? (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final value = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
              setState(() {
                _dragValue = value;
              });
              // Update video position in real-time during drag
              widget.onSeek(_getDurationFromValue(value));
            }
          : null,
      onHorizontalDragEnd: widget.enabled
          ? (details) {
              HapticFeedback.lightImpact();
              setState(() {
                _isDragging = false;
                _dragValue = null;
              });
              widget.onSeekEnd?.call();
            }
          : null,
      onTapUp: widget.enabled
          ? (details) {
              HapticFeedback.lightImpact();
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final value = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
              widget.onSeek(_getDurationFromValue(value));
            }
          : null,
      child: Container(
        height: 48,
        width: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            height: _isDragging ? 10 : 6,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.centerLeft,
                children: [
                  // Background track
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),

                  // Buffer progress
                  FractionallySizedBox(
                    widthFactor: _bufferProgress.clamp(0.0, 1.0),
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),

                  // Progress
                  FractionallySizedBox(
                    widthFactor: displayProgress.clamp(0.0, 1.0),
                    child: Container(color: Colors.white),
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
