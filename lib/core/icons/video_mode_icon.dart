import 'package:desterlib_client/core/interfaces/triggerable_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoModeIcon extends StatefulWidget {
  const VideoModeIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  State<VideoModeIcon> createState() => VideoModeIconState();
}

class VideoModeIconState extends State<VideoModeIcon>
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void trigger() => _controller.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    final stack1Sequence = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 15),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 45,
      ),
    ]);

    final stack2Sequence = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 25),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 10),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]);

    final stack1 = stack1Sequence.animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0)),
    );

    final stack2 = stack2Sequence.animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.15, 1.0)),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/video-mode-icon/main.svg',
              width: widget.size,
              height: widget.size,
              colorFilter: widget.color == null
                  ? null
                  : ColorFilter.mode(widget.color!, BlendMode.srcIn),
            ),
            Transform.translate(
              offset: Offset(0, -2 * stack1.value),
              child: SvgPicture.asset(
                'assets/icons/video-mode-icon/stack-1.svg',
                width: widget.size,
                height: widget.size,
                colorFilter: widget.color == null
                    ? null
                    : ColorFilter.mode(widget.color!, BlendMode.srcIn),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -4 * stack2.value),
              child: SvgPicture.asset(
                'assets/icons/video-mode-icon/stack-2.svg',
                width: widget.size,
                height: widget.size,
                colorFilter: widget.color == null
                    ? null
                    : ColorFilter.mode(widget.color!, BlendMode.srcIn),
              ),
            ),
          ],
        );
      },
    );
  }
}
