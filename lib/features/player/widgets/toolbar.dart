import 'package:desterlib_client/core/icons/back_arrow_icon.dart';
import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white.withValues(alpha: 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
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
          Text("Dune: Part Two", style: TextStyle(color: AppTheme.white)),
        ],
      ),
    );
  }
}
