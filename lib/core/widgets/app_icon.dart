import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:desterlib_client/core/interfaces/triggerable_icon.dart';

abstract final class AppIcons {
  static const home = 'assets/icons/solar-icons/home.svg';
  static const search = 'assets/icons/solar-icons/search.svg';
  static const film = 'assets/icons/solar-icons/film.svg';
  static const tv = 'assets/icons/solar-icons/tv.svg';
  static const link = 'assets/icons/solar-icons/link.svg';
  static const settings = 'assets/icons/solar-icons/settings.svg';
  static const heart = 'assets/icons/solar-icons/heart.svg';
  static const arrowLeft = 'assets/icons/solar-icons/arrow-left.svg';
  static const chevronLeft = 'assets/icons/solar-icons/chevron_left.svg';
  static const filter = 'assets/icons/solar-icons/filter.svg';
  static const folder = 'assets/icons/solar-icons/folder.svg';
  static const folderOpen = 'assets/icons/solar-icons/folder-open.svg';
  static const refresh = 'assets/icons/solar-icons/refresh.svg';

  static const brush = 'assets/icons/solar-icons/brush.svg';
  static const sun = 'assets/icons/solar-icons/sun.svg';
  static const moon = 'assets/icons/solar-icons/moon.svg';

  static const play = 'assets/icons/solar-icons/play.svg';
  static const forward = 'assets/icons/solar-icons/forward.svg';
  static const backward = 'assets/icons/solar-icons/backward.svg';
  static const volumeFull = 'assets/icons/solar-icons/volume_full.svg';
}

class AppIcon extends StatefulWidget {
  const AppIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 24,
    this.rotateAnimate = false,
  });

  final String icon;
  final Color? color;
  final double size;
  final bool rotateAnimate;

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon>
    with SingleTickerProviderStateMixin
    implements TriggerableIcon {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void trigger() {
    if (!widget.rotateAnimate) return;

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      widget.icon,
      width: widget.size,
      height: widget.size,
      colorFilter: widget.color == null
          ? null
          : ColorFilter.mode(widget.color!, BlendMode.srcIn),
    );

    if (widget.rotateAnimate) {
      return RotationTransition(
        turns: Tween<double>(begin: 0, end: 0.5).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        ),
        child: icon,
      );
    }

    return icon;
  }
}
