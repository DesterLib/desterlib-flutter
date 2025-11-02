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

  const DAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.height = 120.0,
    this.maxWidthConstraint,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // Determine if we should show a back button
    final canPop = Navigator.of(context).canPop();
    final shouldShowBackButton = leading == null && canPop;
    final titleStyle = shouldShowBackButton
        ? AppTypography.h2
        : AppTypography.h1;

    return SizedBox(
      height: height,
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
        child: Padding(
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
                  // Title
                  if (!centerTitle)
                    Expanded(child: Text(title, style: titleStyle))
                  else ...[
                    const Spacer(),
                    Text(title, style: AppTypography.h2),
                    const Spacer(),
                  ],
                  // Actions
                  if (actions != null) ...actions! else const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
