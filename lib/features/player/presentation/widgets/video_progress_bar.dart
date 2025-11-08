import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';

/// Custom video progress bar with buffer and seek functionality
class VideoProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Duration buffer;
  final ValueChanged<Duration> onSeek;
  final bool enabled;

  const VideoProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.buffer,
    required this.onSeek,
    this.enabled = true,
  });

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
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
      onHorizontalDragStart: widget.enabled
          ? (details) {
              setState(() {
                _isDragging = true;
                _dragValue = _progress;
              });
            }
          : null,
      onHorizontalDragUpdate: widget.enabled
          ? (details) {
              setState(() {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPosition = box.globalToLocal(details.globalPosition);
                final value = (localPosition.dx / box.size.width).clamp(
                  0.0,
                  1.0,
                );
                _dragValue = value;
              });
            }
          : null,
      onHorizontalDragEnd: widget.enabled
          ? (details) {
              if (_dragValue != null) {
                widget.onSeek(_getDurationFromValue(_dragValue!));
              }
              setState(() {
                _isDragging = false;
                _dragValue = null;
              });
            }
          : null,
      onTapUp: widget.enabled
          ? (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final value = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
              widget.onSeek(_getDurationFromValue(value));
            }
          : null,
      child: Container(
        height: 32,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Background track
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Buffer progress
            FractionallySizedBox(
              widthFactor: _bufferProgress.clamp(0.0, 1.0),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Progress
            FractionallySizedBox(
              widthFactor: displayProgress.clamp(0.0, 1.0),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Thumb indicator
            if (widget.enabled)
              Positioned(
                left:
                    (MediaQuery.of(context).size.width - 48) *
                        displayProgress.clamp(0.0, 1.0) -
                    6,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: _isDragging ? 16 : 12,
                  height: _isDragging ? 16 : 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: _isDragging ? 8 : 4,
                        spreadRadius: _isDragging ? 2 : 0,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Time display widget
class VideoTimeDisplay extends StatelessWidget {
  final Duration position;
  final Duration duration;

  const VideoTimeDisplay({
    super.key,
    required this.position,
    required this.duration,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_formatDuration(position)} / ${_formatDuration(duration)}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}
