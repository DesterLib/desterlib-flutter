import 'package:desterlib_client/core/icons/settings_icon.dart';
import 'package:desterlib_client/core/theme/theme_toggle_action_button.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              "A",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0x00000000),
              ),
            ),
          ),
        ),
        Row(
          spacing: 12,
          children: [
            ThemeToggleActionButton(),
            ActionButton(
              onPressed: () {
                print('Refresh pressed');
              },
              icon: (context, color, size, iconKey) {
                return SettingsIcon(color: color, size: size, key: iconKey);
              },
            ),
          ],
        ),
      ],
    );
  }
}
