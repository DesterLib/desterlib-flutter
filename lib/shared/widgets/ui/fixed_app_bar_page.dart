import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/app_bar.dart';

/// A fixed layout page with app bar - no scrolling or blur effects.
/// Use this for pages where only specific content areas should scroll (like lists).
class FixedAppBarPage extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget Function(bool isScrolled)?
  leadingBuilder; // For consistency with AnimatedAppBarPage
  final bool centerTitle;
  final bool useCompactHeight; // Use 80px height instead of 120px
  final double? maxWidthConstraint;
  final TextStyle? titleStyle;

  const FixedAppBarPage({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.leading,
    this.leadingBuilder,
    this.centerTitle = false,
    this.useCompactHeight = false,
    this.maxWidthConstraint,
    this.titleStyle,
  }) : assert(
         leading == null || leadingBuilder == null,
         'Cannot provide both leading and leadingBuilder',
       );

  @override
  Widget build(BuildContext context) {
    final appBarHeight = useCompactHeight ? 80.0 : 120.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 900;

    // Calculate bottom padding for bottom navigation bar
    final bottomPadding = isMobile
        ? 120.0 // Space for bottom nav bar (80px) + extra padding (40px)
        : 40.0; // Extra padding for desktop

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: DAppBar(
          key: ValueKey('app_bar_$title'),
          title: title,
          actions: actions,
          leading: leadingBuilder != null
              ? leadingBuilder!(false) // Always pass false (not scrolled)
              : leading,
          automaticallyImplyLeading: leadingBuilder == null && leading == null,
          centerTitle: centerTitle,
          height: appBarHeight,
          maxWidthConstraint: maxWidthConstraint,
          showBackground: false, // No blur background
          backgroundOpacity: 0.0,
          titleOpacity: 1.0,
          titleOffset: 0.0,
          titleStyle: titleStyle,
          showCompactTitle: false,
        ),
      ),
      body: Listener(
        onPointerDown: (_) {
          // Dismiss keyboard on any pointer down event (tap, click, etc.)
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: child,
        ),
      ),
    );
  }
}
