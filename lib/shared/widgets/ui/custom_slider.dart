import 'package:flutter/material.dart';

/// A custom slider widget with enhanced styling and interaction
class CustomSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double trackHeight;
  final double thumbRadius;
  final bool enabled;

  const CustomSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.trackHeight = 4.0,
    this.thumbRadius = 8.0,
    this.enabled = true,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double? _dragValue;
  bool _isDragging = false;

  double get _normalizedValue {
    final normalized = ((widget.value - widget.min) / (widget.max - widget.min))
        .clamp(0.0, 1.0);
    return normalized;
  }

  double get _displayValue => _dragValue ?? _normalizedValue;

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled || widget.onChanged == null) return;
    setState(() {
      _isDragging = true;
      _dragValue = _normalizedValue;
    });
    widget.onChangeStart?.call(widget.value);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled || widget.onChanged == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final value = (localPosition.dx / box.size.width).clamp(0.0, 1.0);

    setState(() {
      _dragValue = value;
    });

    final actualValue = widget.min + (value * (widget.max - widget.min));
    widget.onChanged?.call(actualValue);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled || widget.onChanged == null) return;

    final finalValue = widget.min + (_dragValue! * (widget.max - widget.min));
    widget.onChangeEnd?.call(finalValue);

    setState(() {
      _isDragging = false;
      _dragValue = null;
    });
  }

  void _handleTap(TapUpDetails details) {
    if (!widget.enabled || widget.onChanged == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final value = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    final actualValue = widget.min + (value * (widget.max - widget.min));

    widget.onChanged?.call(actualValue);
    widget.onChangeEnd?.call(actualValue);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final inactiveColor =
        widget.inactiveColor ?? Colors.white.withValues(alpha: 0.2);
    final thumbColor = widget.thumbColor ?? activeColor;

    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onTapUp: _handleTap,
      child: Container(
        height: 32,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: SizedBox(
          height: widget.trackHeight,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background track
              Container(
                height: widget.trackHeight,
                decoration: BoxDecoration(
                  color: inactiveColor,
                  borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                ),
              ),

              // Active track
              FractionallySizedBox(
                widthFactor: _displayValue,
                child: Container(
                  height: widget.trackHeight,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                  ),
                ),
              ),

              // Thumb
              if (widget.enabled && widget.onChanged != null)
                Positioned(
                  left:
                      (MediaQuery.of(context).size.width - 48) * _displayValue -
                      widget.thumbRadius,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    width: widget.thumbRadius * 2 * (_isDragging ? 1.2 : 1.0),
                    height: widget.thumbRadius * 2 * (_isDragging ? 1.2 : 1.0),
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: thumbColor.withValues(alpha: 0.4),
                          blurRadius: _isDragging ? 8 : 4,
                          spreadRadius: _isDragging ? 2 : 0,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
