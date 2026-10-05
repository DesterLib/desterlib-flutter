import 'dart:ui';

import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:desterlib_client/core/widgets/app_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          _GlassContainer(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  ActionButton(
                    onPressed: () {
                      context.pop();
                    },
                    iconSize: 16,
                    icon: (context, color, size, iconKey) {
                      return AppIcon(
                        key: iconKey,
                        icon: AppIcons.arrowLeft,
                        color: AppTheme.white,
                        size: size,
                      );
                    },
                  ),
                  Transform.translate(
                    offset: const Offset(0, -1.5),
                    child: Text(
                      'Back',
                      style: TextStyle(color: AppTheme.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _GlassContainer(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -1.5),
                child: Text(
                  'Dune: Part Two',
                  style: TextStyle(color: AppTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  const _GlassContainer({required this.child, this.height, this.padding});

  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(color: AppTheme.playerSurface),
          child: child,
        ),
      ),
    );
  }
}
