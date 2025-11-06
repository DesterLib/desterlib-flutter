import 'package:flutter/material.dart';
import '../../../core/services/websocket_service.dart';

/// Scan progress bar widget
class ScanProgressBar extends StatelessWidget {
  final ScanProgressMessage? progress;
  final double height;

  const ScanProgressBar({super.key, required this.progress, this.height = 4});

  @override
  Widget build(BuildContext context) {
    if (progress == null || (!progress!.isScanning && !progress!.isComplete)) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            child: LinearProgressIndicator(
              value: progress!.progressPercent,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
            ),
          ),
        ),

        // Progress text
        if (progress!.message.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            progress!.message,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Color _getProgressColor() {
    if (progress!.isComplete) {
      return Colors.green;
    } else if (progress!.isError) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}

/// Compact scan progress indicator (for list items)
class CompactScanProgress extends StatelessWidget {
  final ScanProgressMessage progress;

  const CompactScanProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (progress.isScanning)
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(_getIconColor()),
              ),
            )
          else if (progress.isComplete)
            Icon(Icons.check, size: 10, color: _getIconColor())
          else if (progress.isError)
            Icon(Icons.error_outline, size: 10, color: _getIconColor()),
          const SizedBox(width: 5),
          Text(
            progress.isScanning
                ? '${progress.progress}%'
                : progress.isComplete
                ? 'Done'
                : 'Error',
            style: TextStyle(
              fontSize: 10,
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (progress.isComplete) {
      return Colors.green.withValues(alpha: 0.15);
    } else if (progress.isError) {
      return Colors.red.withValues(alpha: 0.15);
    } else {
      return Colors.blue.withValues(alpha: 0.15);
    }
  }

  Color _getIconColor() {
    if (progress.isComplete) {
      return Colors.green.shade400;
    } else if (progress.isError) {
      return Colors.red.shade400;
    } else {
      return Colors.blue.shade400;
    }
  }

  Color _getTextColor() {
    if (progress.isComplete) {
      return Colors.green.shade300;
    } else if (progress.isError) {
      return Colors.red.shade300;
    } else {
      return Colors.blue.shade300;
    }
  }
}
