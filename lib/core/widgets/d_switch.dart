// External packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom pill-style switch widget matching the slider design
/// Can be used as a trailing widget in SettingsItem
class DSwitch extends StatelessWidget {
  final bool value;
  final bool enabled;
  final void Function(bool)? onChanged;

  const DSwitch({
    super.key,
    required this.value,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && onChanged != null
          ? () {
              HapticFeedback.lightImpact();
              onChanged!(!value);
            }
          : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 52.0,
          height: 24.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: value ? Colors.green : Colors.white.withValues(alpha: 0.3),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: value ? 18.0 : 2.0,
                top: 2.0,
                child: Container(
                  width: 32.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
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
