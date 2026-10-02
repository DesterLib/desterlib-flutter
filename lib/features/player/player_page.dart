import 'package:desterlib_client/features/player/widgets/toolbar.dart';
import 'package:flutter/widgets.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000000),
      child: Column(children: [Toolbar()]),
    );
  }
}
