import 'dart:math' as math;

import 'package:desterlib_client/core/widgets/triggerable_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RefreshIcon extends StatefulWidget {
  const RefreshIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  State<RefreshIcon> createState() => RefreshIconState();
}

class RefreshIconState extends State<RefreshIcon>
    with SingleTickerProviderStateMixin
    implements TriggerableIcon {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _rotation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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
      animation: _rotation,
      builder: (context, child) {
        return Transform.rotate(angle: _rotation.value, child: child);
      },
      child: SvgPicture.asset(
        'assets/icons/refresh-icon.svg',
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
