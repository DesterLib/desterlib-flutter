import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayIcon extends StatelessWidget {
  const PlayIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/play-icon.svg',
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
