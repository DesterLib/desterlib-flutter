import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/search-icon.svg',
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
