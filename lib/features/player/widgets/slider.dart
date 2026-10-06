import 'package:flutter/widgets.dart';

class Slider extends StatefulWidget {
  const Slider({
    super.key,
    required this.value,
    this.secondaryValue,
    this.onChanged,
    this.activeColor = const Color(0xFFFFFFFF),
    this.inactiveColor = const Color(0x55FFFFFF),
    this.thumbRadius = 0,
  });

  final double value;
  final double? secondaryValue;
  final ValueChanged<double>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double thumbRadius;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  double? _dragValue;

  void _handlePosition(BuildContext context, Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final localPosition = box.globalToLocal(globalPosition);
    final newValue = (localPosition.dx / box.size.width).clamp(0.0, 1.0);

    setState(() {
      _dragValue = newValue;
    });

    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final value = _dragValue ?? widget.value;
    final clampedValue = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;
    final clampedSecondaryValue = (widget.secondaryValue ?? 0.0).clamp(
      0.0,
      1.0,
    );

    return SizedBox(
      height: 18,
      child: Builder(
        builder: (innerContext) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _handlePosition(innerContext, d.globalPosition),

            onTapUp: (_) {
              setState(() {
                _dragValue = null;
              });
            },

            onHorizontalDragStart: (d) =>
                _handlePosition(innerContext, d.globalPosition),
            onHorizontalDragUpdate: (d) =>
                _handlePosition(innerContext, d.globalPosition),
            onHorizontalDragEnd: (_) {
              setState(() {
                _dragValue = null;
              });
            },
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                height: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8 / 2),
                  child: Stack(
                    children: [
                      // Track
                      Positioned.fill(
                        child: ColoredBox(color: widget.inactiveColor),
                      ),

                      // Buffered
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: clampedSecondaryValue,
                          heightFactor: 1.0,
                          child: ColoredBox(
                            color: widget.activeColor.withValues(alpha: 0.2),
                          ),
                        ),
                      ),

                      // Progress
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: clampedValue,
                          heightFactor: 1.0,
                          child: ColoredBox(color: widget.activeColor),
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
