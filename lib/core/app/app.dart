import 'package:desterlib_client/core/router/router.dart';
import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/core/theme/theme_controller.dart';
import 'package:flutter/widgets.dart';

class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    super.key,
    required AppThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppThemeController controllerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'No AppThemeScope found in context');
    return scope!.notifier!;
  }

  static AppTheme of(BuildContext context) => controllerOf(context).theme;
}

class DesterApp extends StatefulWidget {
  const DesterApp({super.key});

  @override
  State<DesterApp> createState() => _DesterAppState();
}

class _DesterAppState extends State<DesterApp> {
  final _controller = AppThemeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp.router(
      debugShowCheckedModeBanner: false,
      color: const Color(0xFFEEF2FF),
      routerConfig: router,
      builder: (context, child) {
        return AppThemeScope(
          controller: _controller,
          child: _ThemedSubtree(child: child!),
        );
      },
    );
  }
}

class _ThemedSubtree extends StatelessWidget {
  const _ThemedSubtree({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeScope.of(context);

    return DefaultTextStyle(
      style: theme.textTheme.body,
      child: ColoredBox(color: theme.surfaceLight, child: child),
    );
  }
}
