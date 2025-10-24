import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:dester/shared/widgets/ui/app_bar.dart';

class AnimatedAppBarPage extends StatefulWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double appBarHeight;
  final double? maxWidthConstraint;

  const AnimatedAppBarPage({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.appBarHeight = 120.0,
    this.maxWidthConstraint,
  });

  @override
  State<AnimatedAppBarPage> createState() => _AnimatedAppBarPageState();
}

class _AnimatedAppBarPageState extends State<AnimatedAppBarPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  double _lastUpdateOffset = 0.0;

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
    // Throttle updates - only update if scroll changed by more than 2 pixels
    final currentOffset = _scrollController.offset;
    if ((currentOffset - _lastUpdateOffset).abs() > 2.0) {
      setState(() {
        _scrollOffset = currentOffset;
        _lastUpdateOffset = currentOffset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: widget.appBarHeight),
                RepaintBoundary(child: widget.child),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Blur overlay for status bar only
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight,
            child: IgnorePointer(
              child: RepaintBoundary(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      color: const Color(0xFF0a0a0a).withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // AppBar - content animates out naturally
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: DAppBar(
                title: widget.title,
                scrollOffset: _scrollOffset,
                actions: widget.actions,
                leading: widget.leading,
                centerTitle: widget.centerTitle,
                height: widget.appBarHeight,
                maxWidthConstraint: widget.maxWidthConstraint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
