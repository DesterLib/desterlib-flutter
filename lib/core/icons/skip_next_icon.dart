import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SkipNextIcon extends StatelessWidget {
  const SkipNextIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/skip-next-icon.svg',
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
