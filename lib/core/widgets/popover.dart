import 'dart:ui';

import 'package:flutter/material.dart';

class Popover extends StatefulWidget {
  const Popover({
    super.key,
    required this.trigger,
    required this.content,
    this.width,
    this.height,
    this.offset = const Offset(0, 8),
    this.targetAnchor = Alignment.bottomCenter,
    this.followerAnchor = Alignment.topCenter,
  });

  final Widget Function(BuildContext context, VoidCallback toggle) trigger;
  final Widget Function(BuildContext context, VoidCallback close) content;

  final double? width;
  final double? height;

  final Offset offset;
  final Alignment targetAnchor;
  final Alignment followerAnchor;

  @override
  State<Popover> createState() => PopoverState();
}

class PopoverState extends State<Popover> {
  final LayerLink _link = LayerLink();

  final GlobalKey<_PopoverAnimationState> _animationKey =
      GlobalKey<_PopoverAnimationState>();

  OverlayEntry? _entry;

  bool _isOpen = false;

  void toggle() {
    if (_isOpen) {
      close();
    } else {
      open();
    }
  }

  void open() {
    if (_entry != null) {
      return;
    }

    final entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: close,
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              targetAnchor: widget.targetAnchor,
              followerAnchor: widget.followerAnchor,
              offset: widget.offset,
              child: _PopoverAnimation(
                key: _animationKey,
                followerAnchor: widget.followerAnchor,
                child: _PopoverShell(
                  width: widget.width,
                  height: widget.height,
                  child: widget.content(context, close),
                ),
              ),
            ),
          ],
        );
      },
    );

    _entry = entry;

    Overlay.of(context, rootOverlay: true).insert(entry);

    setState(() {
      _isOpen = true;
    });
  }

  void close() {
    final entry = _entry;

    if (entry == null) {
      return;
    }

    final animation = _animationKey.currentState;

    if (animation == null) {
      _removeOverlay(entry);
      return;
    }

    animation.close(
      onDone: () {
        _removeOverlay(entry);
      },
    );
  }

  void _removeOverlay(OverlayEntry entry) {
    if (_entry != entry) {
      return;
    }

    entry.remove();
    _entry = null;

    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  @override
  void dispose() {
    _entry?.remove();
    _entry = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: widget.trigger(context, toggle),
    );
  }
}

class _PopoverAnimation extends StatefulWidget {
  const _PopoverAnimation({
    super.key,
    required this.child,
    required this.followerAnchor,
  });

  final Widget child;
  final Alignment followerAnchor;

  @override
  State<_PopoverAnimation> createState() => _PopoverAnimationState();
}

class _PopoverAnimationState extends State<_PopoverAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  bool _closing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 110),
    );

    _scale = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  void close({required VoidCallback onDone}) {
    if (_closing) {
      return;
    }

    _closing = true;

    _controller.reverse().whenComplete(() {
      if (mounted) {
        onDone();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        alignment: widget.followerAnchor,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _PopoverShell extends StatelessWidget {
  const _PopoverShell({required this.child, this.width, this.height});

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            color: Color.fromARGB(210, 250, 250, 250),
          ),
          child: child,
        ),
      ),
    );
  }
}
