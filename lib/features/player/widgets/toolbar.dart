import 'package:desterlib_client/core/icons/back_arrow_icon.dart';
import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppTheme.white.withValues(alpha: 0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  ActionButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: (context, color, size, iconKey) {
                      return BackArrowIcon(
                        color: AppTheme.white,
                        size: size,
                        key: iconKey,
                      );
                    },
                  ),
                  Transform.translate(
                    offset: const Offset(0, -1.5),
                    child: Text(
                      "Back",
                      style: TextStyle(color: AppTheme.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppTheme.white.withValues(alpha: 0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -1.5),
                  child: Text(
                    "Dune: Part Two",
                    style: TextStyle(color: AppTheme.white),
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
