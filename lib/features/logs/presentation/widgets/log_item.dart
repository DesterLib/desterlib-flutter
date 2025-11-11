import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dester/core/services/websocket_service.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';

class LogItem extends StatefulWidget {
  final LogMessage log;
  final VoidCallback? onTap;

  const LogItem({super.key, required this.log, this.onTap});

  @override
  State<LogItem> createState() => _LogItemState();
}

class _LogItemState extends State<LogItem> {
  bool _isHovered = false;

  Color _getLevelColor() {
    switch (widget.log.level.toLowerCase()) {
      case 'error':
        return Colors.red.shade400;
      case 'warn':
        return Colors.orange.shade400;
      case 'info':
        return Colors.blue.shade400;
      case 'http':
        return Colors.purple.shade400;
      case 'debug':
        return Colors.grey.shade400;
      default:
        return Colors.white;
    }
  }

  IconData _getLevelIcon() {
    switch (widget.log.level.toLowerCase()) {
      case 'error':
        return PlatformIcons.errorCircle;
      case 'warn':
        return PlatformIcons.warning;
      case 'info':
        return PlatformIcons.info;
      case 'http':
        return Icons.cloud_outlined;
      case 'debug':
        return PlatformIcons.code;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor();
    final hasMetadata =
        widget.log.meta != null && (widget.log.meta as Map).isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap != null
            ? () {
                HapticFeedback.lightImpact();
                widget.onTap!();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Level icon with background
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: ShapeDecoration(
                  color: levelColor.withValues(alpha: 0.15),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Icon(_getLevelIcon(), size: 16, color: levelColor),
              ),
              AppSpacing.gapHorizontalSM,
              // Timestamp
              SizedBox(
                width: 140,
                child: Text(
                  widget.log.timestamp,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'monospace',
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              AppSpacing.gapHorizontalSM,
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: ShapeDecoration(
                  color: levelColor.withValues(alpha: 0.15),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  widget.log.level.toUpperCase(),
                  style: TextStyle(
                    color: levelColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              AppSpacing.gapHorizontalSM,
              // Message
              Expanded(
                child: Text(
                  widget.log.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Metadata indicator
              if (hasMetadata) ...[
                AppSpacing.gapHorizontalSM,
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Icon(
                    Icons.data_object,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
