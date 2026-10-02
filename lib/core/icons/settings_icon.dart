import 'dart:math' as math;

import 'package:desterlib_client/core/interfaces/triggerable_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsIcon extends StatefulWidget {
  const SettingsIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  State<SettingsIcon> createState() => SettingsIconState();
}

class SettingsIconState extends State<SettingsIcon>
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
      end: math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void trigger() => _controller.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) {
        return Transform.rotate(angle: _rotation.value, child: child);
      },
      child: SvgPicture.asset(
        'assets/icons/settings-icon.svg',
        width: widget.size,
        height: widget.size,
        colorFilter: widget.color == null
            ? null
            : ColorFilter.mode(widget.color!, BlendMode.srcIn),
      ),
    );
  }
}
