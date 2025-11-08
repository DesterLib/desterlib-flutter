import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'player_overlay_base.dart';

/// Overlay for selecting playback speed
class SpeedSelectorOverlay extends StatefulWidget {
  final double currentSpeed;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onClose;

  const SpeedSelectorOverlay({
    super.key,
    required this.currentSpeed,
    required this.onSpeedChanged,
    required this.onClose,
  });

  @override
  State<SpeedSelectorOverlay> createState() => _SpeedSelectorOverlayState();
}

class _SpeedSelectorOverlayState extends State<SpeedSelectorOverlay> {
  final GlobalKey<BaseOverlayState> _overlayKey = GlobalKey();

  static const speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  void _handleSpeedSelect(double speed) {
    widget.onSpeedChanged(speed);
    _overlayKey.currentState?.animateClose();
  }

  void _handleClose() {
    _overlayKey.currentState?.animateClose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return BaseOverlay(
      key: _overlayKey,
      onClose: widget.onClose,
      child: GestureDetector(
        onTap: () {}, // Prevent closing when tapping inside
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 500 : double.infinity,
              maxHeight: isDesktop ? 600 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Playback Speed',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gapVerticalLG,
                  // Speed options
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _SpeedSelectorOverlayState.speeds.length,
                        itemBuilder: (context, index) {
                          final speed =
                              _SpeedSelectorOverlayState.speeds[index];
                          final isSelected = speed == widget.currentSpeed;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () => _handleSpeedSelect(speed),
                              borderRadius: AppRadius.radiusMD,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : Colors.transparent,
                                  borderRadius: AppRadius.radiusMD,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${speed}x',
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFFFFFFFF)
                                            : const Color(0x99FFFFFF),
                                        fontSize: 16,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_rounded,
                                        color: Color(0xFFFFFFFF),
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  AppSpacing.gapVerticalMD,
                  // Close button (right-aligned)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DButton(
                        label: 'Close',
                        variant: DButtonVariant.secondary,
                        size: DButtonSize.sm,
                        onTap: _handleClose,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
