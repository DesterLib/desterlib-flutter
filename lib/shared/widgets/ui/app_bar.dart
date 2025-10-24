import 'package:flutter/material.dart';

class DAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double height;
  final double scrollOffset;
  final double? maxWidthConstraint;

  const DAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.height = 120.0,
    this.scrollOffset = 0.0,
    this.maxWidthConstraint,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // Calculate animation progress (0.0 to 1.0) based on scroll offset
    // Starts animating at 0px, completes at 40px
    final animationProgress = (scrollOffset / 40.0).clamp(0.0, 1.0);

    // Calculate opacity (fades out)
    final opacity = 1.0 - animationProgress;

    // Calculate vertical offset (moves up)
    final verticalOffset = -20.0 * animationProgress;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Gradient mask that fades content underneath
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),
          // App bar content - positioned to center vertically
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            height: height - MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: maxWidthConstraint != null 
                    ? BoxConstraints(maxWidth: maxWidthConstraint!)
                    : const BoxConstraints(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  // Always show leading (back button) if provided - no animation
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 12),
                  ],
                  // Animated title section
                  if (!centerTitle)
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(0, verticalOffset),
                        child: Opacity(
                          opacity: opacity,
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    )
                  else ...[
                    const Spacer(),
                    Transform.translate(
                      offset: Offset(0, verticalOffset),
                      child: Opacity(
                        opacity: opacity,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                  // Always show actions - no animation
                  if (actions != null)
                    ...actions!
                  else
                    const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
