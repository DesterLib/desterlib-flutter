import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SnapshotFadeSwitcher extends StatefulWidget {
  const SnapshotFadeSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Duration duration;

  @override
  State<SnapshotFadeSwitcher> createState() => _SnapshotFadeSwitcherState();
}

class _SnapshotFadeSwitcherState extends State<SnapshotFadeSwitcher>
    with SingleTickerProviderStateMixin {
  final _boundaryKey = GlobalKey();

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _opacity = ReverseAnimation(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ),
  );

  ui.Image? _snapshot;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(_clearSnapshot);
      }
    });
  }

  @override
  void didUpdateWidget(covariant SnapshotFadeSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child.key != widget.child.key) _fadeFromOldPage();
  }

  void _fadeFromOldPage() {
    final boundary =
        _boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;

    try {
      final image = boundary.toImageSync(
        pixelRatio: MediaQuery.devicePixelRatioOf(context),
      );
      _clearSnapshot();
      _snapshot = image;
    } catch (_) {
      return;
    }

    _controller.value = 0;
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted && _snapshot != null) _controller.forward(from: 0);
    });
  }

  void _clearSnapshot() {
    _snapshot?.dispose();
    _snapshot = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _clearSnapshot();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        RepaintBoundary(key: _boundaryKey, child: widget.child),
        if (_snapshot != null)
          Positioned.fill(
            child: IgnorePointer(
              child: FadeTransition(
                opacity: _opacity,
                child: RawImage(image: _snapshot, fit: BoxFit.fill),
              ),
            ),
          ),
      ],
    );
  }
}
