import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/app_bar.dart';

class AnimatedAppBarPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final childWidget = maxWidthConstraint != null
        ? ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidthConstraint!),
            child: child,
          )
        : child;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: DAppBar(
          title: title,
          actions: actions,
          leading: leading,
          centerTitle: centerTitle,
          height: appBarHeight,
          maxWidthConstraint: maxWidthConstraint,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: childWidget,
      ),
    );
  }
}
