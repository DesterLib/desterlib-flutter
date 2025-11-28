// External packages
import 'package:flutter/material.dart';

/// Custom pill-shaped thumb for the slider
class _PillSliderThumbShape extends SliderComponentShape {
  final double thumbWidth;
  final double thumbHeight;

  const _PillSliderThumbShape({
    this.thumbWidth = 32.0,
    this.thumbHeight = 20.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Create a pill shape (elongated rounded rectangle)
    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: thumbWidth,
      height: thumbHeight,
    );

    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    final RRect rRect = RRect.fromRectAndRadius(
      thumbRect,
      Radius.circular(thumbHeight / 2),
    );

    canvas.drawRRect(rRect, paint);
  }
}

/// Custom pill-style slider widget matching the switch design
/// Can be used as a trailing widget in SettingsItem
class DSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double)? labelBuilder;
  final bool enabled;
  final void Function(double)? onChanged;

  const DSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.labelBuilder,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<DSlider> createState() => _DSliderState();
}

class _DSliderState extends State<DSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(DSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayValue =
        widget.labelBuilder?.call(_currentValue) ??
        _currentValue.toInt().toString();

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const _PillSliderThumbShape(
          thumbWidth: 32.0,
          thumbHeight: 20.0,
        ),
        activeTrackColor: Colors.white,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
        thumbColor: Colors.white,
        overlayColor: Colors.transparent,
        trackHeight: 4.0,
      ),
      child: Slider(
        value: _currentValue,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        label: displayValue,
        onChanged: widget.enabled
            ? (value) {
                setState(() {
                  _currentValue = value;
                });
                widget.onChanged?.call(value);
              }
            : null,
      ),
    );
  }
}
