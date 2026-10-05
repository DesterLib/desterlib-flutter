import 'package:flutter/widgets.dart';

class Slider extends StatelessWidget {
  const Slider({
    super.key,
    required this.value,
    required this.onChanged,
    this.height = 24,
    this.trackHeight = 8,
    this.activeColor = const Color(0xFFFFFFFF),
    this.inactiveColor = const Color(0x55FFFFFF),
    this.thumbRadius = 0,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double height;
  final double trackHeight;
  final Color activeColor;
  final Color inactiveColor;
  final double thumbRadius;

  void _handlePosition(BuildContext context, Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final localPosition = box.globalToLocal(globalPosition);
    final newValue = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      height: height,
      child: Builder(
        builder: (innerContext) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _handlePosition(innerContext, d.globalPosition),
            onHorizontalDragStart: (d) =>
                _handlePosition(innerContext, d.globalPosition),
            onHorizontalDragUpdate: (d) =>
                _handlePosition(innerContext, d.globalPosition),
            child: Center(
              child: SizedBox(
                height: trackHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(trackHeight / 2),
                  child: Stack(
                    children: [
                      // Track
                      Positioned.fill(child: ColoredBox(color: inactiveColor)),

                      // Progress
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: clampedValue,
                          heightFactor: 1.0,
                          child: ColoredBox(color: activeColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
