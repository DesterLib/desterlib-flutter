import 'package:desterlib_client/core/app/app_background_state.dart';
import 'package:desterlib_client/core/app/sidebar.dart';
import 'package:desterlib_client/core/app/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, required this.background});

  final Widget child;
  final AppBackgroundState background;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toolbar(background: background),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                SizedBox(width: 200, child: Sidebar()),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
