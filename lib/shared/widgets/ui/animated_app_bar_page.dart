import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/app_bar.dart';

class AnimatedAppBarPage extends StatefulWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget Function(bool isScrolled)?
  leadingBuilder; // Dynamic leading based on scroll state
  final bool centerTitle;
  final bool useCompactHeight; // Use 80px height instead of 120px
  final double? maxWidthConstraint;
  final bool extendBodyBehindAppBar;
  final bool addBottomNavPadding;
  final bool
  addTopPadding; // Add top padding when extendBodyBehindAppBar is true
  final bool
  showTitleOnScroll; // Reverse animation: fade IN on scroll instead of OUT
  final double?
  scrollThresholdForTitle; // Custom scroll distance before title appears
  final TextStyle? titleStyle;

  const AnimatedAppBarPage({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.leading,
    this.leadingBuilder,
    this.centerTitle = false,
    this.useCompactHeight = false,
    this.maxWidthConstraint,
    this.extendBodyBehindAppBar = true,
    this.addBottomNavPadding = true,
    this.addTopPadding = true, // Default to true for backward compatibility
    this.showTitleOnScroll = false,
    this.scrollThresholdForTitle,
    this.titleStyle,
  }) : assert(
         leading == null || leadingBuilder == null,
         'Cannot provide both leading and leadingBuilder',
       );

  @override
  State<AnimatedAppBarPage> createState() => _AnimatedAppBarPageState();
}

class _AnimatedAppBarPageState extends State<AnimatedAppBarPage> {
  final ScrollController _scrollController = ScrollController();
  late double _scrollOffset;

  @override
  void initState() {
    super.initState();
    // Initialize scroll offset based on top padding
    // If no top padding and body extends behind app bar, start as "scrolled"
    final appBarHeight = widget.useCompactHeight ? 80.0 : 120.0;
    _scrollOffset = (!widget.addTopPadding && widget.extendBodyBehindAppBar)
        ? appBarHeight
        : 0.0;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = widget.useCompactHeight ? 80.0 : 120.0;

    final childWidget = widget.maxWidthConstraint != null
        ? Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.maxWidthConstraint!),
              child: widget.child,
            ),
          )
        : widget.child;

    // Calculate opacity and offset based on scroll position
    const fadeDistance = 40.0;
    final scrollThreshold = widget.scrollThresholdForTitle ?? 0.0;

    final opacity = widget.showTitleOnScroll
        ? ((_scrollOffset - scrollThreshold) / fadeDistance).clamp(
            0.0,
            1.0,
          ) // Fade IN after threshold
        : (1.0 - (_scrollOffset / fadeDistance)).clamp(
            0.0,
            1.0,
          ); // Fade OUT on scroll

    // For showTitleOnScroll, keep title at original position (no offset)
    // For normal mode, shift title up as it fades out
    final offset = widget.showTitleOnScroll
        ? 0.0 // No offset - stay at original position
        : _scrollOffset.clamp(0.0, fadeDistance) *
              0.5; // Shift up by half the scroll amount

    // Calculate bottom padding for bottom navigation bar
    // Bottom nav is ~68px total (60px pill + 8px padding)
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth <= 900;
    final bottomPadding = widget.addBottomNavPadding && isMobile
        ? 120.0 // Space for bottom nav bar (80px) + extra padding (40px)
        : 40.0; // Extra padding for desktop

    // Show background when scrolled
    // For showTitleOnScroll mode, show on desktop too; otherwise only on mobile
    final backgroundThreshold = scrollThreshold;
    final showBackground = widget.showTitleOnScroll
        ? _scrollOffset > backgroundThreshold
        : (isMobile && _scrollOffset > fadeDistance);
    final backgroundOpacity =
        ((_scrollOffset - backgroundThreshold) / fadeDistance).clamp(0.0, 1.0);

    return Scaffold(
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: DAppBar(
          title: widget.title,
          actions: widget.actions,
          leading: widget.leadingBuilder != null
              ? widget.leadingBuilder!(showBackground)
              : widget.leading,
          centerTitle: widget.centerTitle,
          height: appBarHeight,
          maxWidthConstraint: widget.maxWidthConstraint,
          showBackground: showBackground,
          backgroundOpacity: backgroundOpacity,
          titleOpacity: opacity,
          titleOffset: -offset,
          titleStyle: widget.titleStyle,
          showCompactTitle: !widget.showTitleOnScroll && showBackground,
        ),
      ),
      body: Listener(
        onPointerDown: (_) {
          // Dismiss keyboard on any pointer down event (tap, click, etc.)
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add top padding when body extends behind app bar (if enabled)
                if (widget.extendBodyBehindAppBar && widget.addTopPadding)
                  SizedBox(height: appBarHeight),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: childWidget,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
