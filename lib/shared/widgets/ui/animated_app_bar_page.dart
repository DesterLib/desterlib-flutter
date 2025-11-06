import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/app_bar.dart';

class AnimatedAppBarPage extends StatefulWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double appBarHeight;
  final double? maxWidthConstraint;
  final bool extendBodyBehindAppBar;

  const AnimatedAppBarPage({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.appBarHeight = 120.0,
    this.maxWidthConstraint,
    this.extendBodyBehindAppBar = false,
  });

  @override
  State<AnimatedAppBarPage> createState() => _AnimatedAppBarPageState();
}

class _AnimatedAppBarPageState extends State<AnimatedAppBarPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
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
    final childWidget = widget.maxWidthConstraint != null
        ? Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.maxWidthConstraint!),
              child: widget.child,
            ),
          )
        : widget.child;

    // Calculate opacity and offset based on scroll position
    // Fade out over 40px of scrolling
    const fadeDistance = 40.0;
    final opacity = (1.0 - (_scrollOffset / fadeDistance)).clamp(0.0, 1.0);
    final offset =
        _scrollOffset.clamp(0.0, fadeDistance) *
        0.5; // Shift up by half the scroll amount

    return Scaffold(
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(widget.appBarHeight),
        child: DAppBar(
          title: widget.title,
          actions: widget.actions,
          leading: widget.leading,
          centerTitle: widget.centerTitle,
          height: widget.appBarHeight,
          maxWidthConstraint: widget.maxWidthConstraint,
          showBackground: false,
          titleOpacity: opacity,
          titleOffset: -offset,
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: childWidget,
      ),
    );
  }
}
