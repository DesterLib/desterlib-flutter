import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/platform_icons.dart';
import '../../../app/theme/theme.dart';

enum DToastType { success, error, info, warning }

class DToast {
  /// Show a toast notification
  static void show(
    BuildContext context, {
    required String message,
    DToastType type = DToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          _DToastWidget(message: message, type: type, duration: duration),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after duration
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class _DToastWidget extends StatefulWidget {
  final String message;
  final DToastType type;
  final Duration duration;

  const _DToastWidget({
    required this.message,
    required this.type,
    required this.duration,
  });

  @override
  State<_DToastWidget> createState() => _DToastWidgetState();
}

class _DToastWidgetState extends State<_DToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );

    _controller.forward();

    // Start exit animation before removal
    Future.delayed(widget.duration - const Duration(milliseconds: 350), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case DToastType.success:
        return AppColors.success;
      case DToastType.error:
        return AppColors.error;
      case DToastType.warning:
        return Colors.orange;
      case DToastType.info:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case DToastType.success:
        return PlatformIcons.checkCircle;
      case DToastType.error:
        return PlatformIcons.errorCircle;
      case DToastType.warning:
        return PlatformIcons.warning;
      case DToastType.info:
        return PlatformIcons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 900;
    final bottomPadding = showSidebar
        ? 16.0
        : MediaQuery.of(context).padding.bottom + 80;

    return Positioned(
      bottom: bottomPadding,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.grey.shade900.withValues(alpha: 0.85),
                          shape: RoundedSuperellipseBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 0.5,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Status icon
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _backgroundColor.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _icon,
                                  color: _backgroundColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Message
                              Flexible(
                                child: Text(
                                  widget.message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.2,
                                  ),
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
          ),
        ),
      ),
    );
  }
}
