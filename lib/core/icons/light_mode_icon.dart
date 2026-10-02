import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LightModeIcon extends StatelessWidget {
  const LightModeIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: SvgPicture.asset(
        'assets/icons/light-mode-icon.svg',
        width: size,
        height: size,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
      ),
    );
  }
}
