import 'package:desterlib_client/core/app/profile.dart';
import 'package:desterlib_client/core/icons/folder_icon.dart';
import 'package:desterlib_client/core/widgets/button.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        Button(
          variant: ButtonVariant.ghost,
          label: "Movies",
          onPressed: () {},
          icon: (context, color, size, iconKey) {
            return FolderIcon(color: color, size: size, key: iconKey);
          },
        ),
        Button(
          variant: ButtonVariant.ghost,
          label: "TV Shows",
          onPressed: () {},
          icon: (context, color, size, iconKey) {
            return FolderIcon(color: color, size: size, key: iconKey);
          },
        ),
        Button(
          variant: ButtonVariant.ghost,
          label: "Anime",
          onPressed: () {},
          icon: (context, color, size, iconKey) {
            return FolderIcon(color: color, size: size, key: iconKey);
          },
        ),
        const Spacer(),
        Profile(),
      ],
    );
  }
}
