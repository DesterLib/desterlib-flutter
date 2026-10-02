import 'package:desterlib_client/core/icons/back_arrow_icon.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionButton(
            onPressed: () {
              context.pop();
            },
            icon: (context, color, size, iconKey) {
              return BackArrowIcon(color: color, size: size, key: iconKey);
            },
          ),
          Text("Dune: Part Two", style: TextStyle()),
        ],
      ),
    );
  }
}
