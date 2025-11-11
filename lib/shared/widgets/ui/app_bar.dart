import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dester/app/theme/theme.dart';

class DAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double height;
  final double? maxWidthConstraint;
  final bool showBackground;
  final double backgroundOpacity;
  final double titleOpacity;
  final double titleOffset;
  final TextStyle? titleStyle;
  final bool showCompactTitle; // Show compact title in appbar when scrolled
  final bool
  automaticallyImplyLeading; // Show automatic back button if no leading provided

  const DAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.height = 120.0,
    this.maxWidthConstraint,
    this.showBackground = true,
    this.backgroundOpacity = 1.0,
    this.titleOpacity = 1.0,
    this.titleOffset = 0.0,
    this.titleStyle,
    this.showCompactTitle = false,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // Determine if we should show a back button
    final canPop = Navigator.of(context).canPop();
    final shouldShowBackButton =
        automaticallyImplyLeading && leading == null && canPop;
    final effectiveTitleStyle =
        titleStyle ??
        (shouldShowBackButton ? AppTypography.h2 : AppTypography.h1);

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Background with blur (bottom nav style)
          if (showBackground)
            Positioned.fill(
              child: Opacity(
                opacity: backgroundOpacity,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade800.withValues(alpha: 0.2),
                            width: 0.33,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 20,
              right: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: maxWidthConstraint != null
                    ? BoxConstraints(maxWidth: maxWidthConstraint!)
                    : const BoxConstraints(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Leading widget or back button
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 12),
                    ] else if (shouldShowBackButton) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                    ],
                    // Title (large title or compact title based on scroll)
                    if (showCompactTitle) ...[
                      // Compact title is always centered
                      const Spacer(),
                      Opacity(
                        opacity: backgroundOpacity,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: AppTypography.fontSizeLG,
                            fontWeight: AppTypography.semiBold,
                            color: AppColors.textPrimary,
                            letterSpacing: AppTypography.letterSpacingTight,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ] else if (!centerTitle)
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, titleOffset),
                          child: Opacity(
                            opacity: titleOpacity,
                            child: Text(title, style: effectiveTitleStyle),
                          ),
                        ),
                      )
                    else ...[
                      const Spacer(),
                      Transform.translate(
                        offset: Offset(0, titleOffset),
                        child: Opacity(
                          opacity: titleOpacity,
                          child: Text(title, style: effectiveTitleStyle),
                        ),
                      ),
                      const Spacer(),
                    ],
                    // Actions
                    if (actions != null)
                      ...actions!
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
