import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'shared/widgets/keyboard_shortcuts_dialog.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dester',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: (context, child) {
        return KeyboardShortcutsWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.digit1): const NavigateToHomeIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpad1): const NavigateToHomeIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit2):
            const NavigateToLibraryIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpad2):
            const NavigateToLibraryIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit3):
            const NavigateToSettingsIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpad3):
            const NavigateToSettingsIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.slash):
            const ShowKeyboardShortcutsIntent(),
      },
      actions: {
        NavigateToHomeIntent: CallbackAction<NavigateToHomeIntent>(
          onInvoke: (intent) {
            router.go('/home');
            return null;
          },
        ),
        NavigateToLibraryIntent: CallbackAction<NavigateToLibraryIntent>(
          onInvoke: (intent) {
            router.go('/library');
            return null;
          },
        ),
        NavigateToSettingsIntent: CallbackAction<NavigateToSettingsIntent>(
          onInvoke: (intent) {
            router.go('/settings');
            return null;
          },
        ),
        ShowKeyboardShortcutsIntent:
            CallbackAction<ShowKeyboardShortcutsIntent>(
              onInvoke: (intent) => null, // Handled by KeyboardShortcutsWrapper
            ),
      },
    );
  }
}

// Wrapper to handle keyboard shortcuts dialog
class KeyboardShortcutsWrapper extends StatefulWidget {
  final Widget child;

  const KeyboardShortcutsWrapper({required this.child, super.key});

  @override
  State<KeyboardShortcutsWrapper> createState() =>
      _KeyboardShortcutsWrapperState();
}

class _KeyboardShortcutsWrapperState extends State<KeyboardShortcutsWrapper> {
  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        ShowKeyboardShortcutsIntent:
            CallbackAction<ShowKeyboardShortcutsIntent>(
              onInvoke: (intent) {
                KeyboardShortcutsDialog.show(context);
                return null;
              },
            ),
      },
      child: widget.child,
    );
  }
}

// Navigation Intents
class NavigateToHomeIntent extends Intent {
  const NavigateToHomeIntent();
}

class NavigateToLibraryIntent extends Intent {
  const NavigateToLibraryIntent();
}

class NavigateToSettingsIntent extends Intent {
  const NavigateToSettingsIntent();
}

class ShowKeyboardShortcutsIntent extends Intent {
  const ShowKeyboardShortcutsIntent();
}
