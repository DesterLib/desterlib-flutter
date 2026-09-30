import 'package:flutter/widgets.dart';

class FadeImage extends StatelessWidget {
  const FadeImage({
    super.key,
    required this.child,
    this.leftFade = 0.2,
    this.bottomFade = 0.2,
  });

  final Widget child;
  final double leftFade;
  final double bottomFade;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0, leftFade],
          colors: const [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
        ).createShader(bounds);
      },
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1 - bottomFade],
            colors: const [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
          ).createShader(bounds);
        },
        child: child,
      ),
    );
  }
}
