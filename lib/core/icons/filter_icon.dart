import 'package:desterlib_client/core/widgets/triggerable_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterIcon extends StatefulWidget {
  const FilterIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  State<FilterIcon> createState() => FilterIconState();
}

class FilterIconState extends State<FilterIcon>
    with SingleTickerProviderStateMixin
    implements TriggerableIcon {
  late final AnimationController _controller;

  late final Animation<double> _stack1;
  late final Animation<double> _stack2;
  late final Animation<double> _stack3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _stack1 = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55,
      ),
    ]).animate(_controller);

    _stack2 = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 12),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _stack3 = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 24),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 31,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 45,
      ),
    ]).animate(_controller);
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
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, 2 * _stack1.value),
              child: _asset('stack-1.svg'),
            ),
            Transform.translate(
              offset: Offset(0, 0 * _stack2.value),
              child: _asset('stack-2.svg'),
            ),
            Transform.translate(
              offset: Offset(0, -2 * _stack3.value),
              child: _asset('stack-3.svg'),
            ),
          ],
        );
      },
    );
  }

  Widget _asset(String name) {
    return SvgPicture.asset(
      'assets/icons/filter-icon/$name',
      width: widget.size,
      height: widget.size,
      colorFilter: widget.color == null
          ? null
          : ColorFilter.mode(widget.color!, BlendMode.srcIn),
    );
  }
}
