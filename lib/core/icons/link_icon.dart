import 'dart:math' as math;

import 'package:desterlib_client/core/widgets/triggerable_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkIcon extends StatefulWidget {
  const LinkIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  State<LinkIcon> createState() => LinkIconState();
}

class LinkIconState extends State<LinkIcon>
    with SingleTickerProviderStateMixin
    implements TriggerableIcon {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void trigger() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;

        final rotation = math.sin(value * math.pi * 2) * (math.pi / 18);

        final scale = 1.0 - math.sin(value * math.pi) * 0.08;

        return Transform.rotate(
          angle: rotation,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: SvgPicture.asset(
        'assets/icons/link-icon.svg',
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        colorFilter: widget.color == null
            ? null
            : ColorFilter.mode(widget.color!, BlendMode.srcIn),
      ),
    );
  }
}
