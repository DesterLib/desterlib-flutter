import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FolderIcon extends StatelessWidget {
  const FolderIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: SvgPicture.asset(
        'assets/icons/folder-icon.svg',
        width: size,
        height: size,
      ),
    );
  }
}
