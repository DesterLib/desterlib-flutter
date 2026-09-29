import 'package:desterlib_client/core/router/router.dart';
import 'package:flutter/widgets.dart';

class DesterApp extends StatefulWidget {
  const DesterApp({super.key});

  @override
  State<DesterApp> createState() => _DesterAppState();
}

class _DesterAppState extends State<DesterApp> {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp.router(
      debugShowCheckedModeBanner: false,
      color: const Color(0xFFEEF2FF),
      routerConfig: router,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
