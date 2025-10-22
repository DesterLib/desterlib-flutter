import 'package:flutter/material.dart';

/// Dialog that displays available keyboard shortcuts
class KeyboardShortcutsDialog extends StatelessWidget {
  const KeyboardShortcutsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const KeyboardShortcutsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.keyboard, color: colorScheme.primary, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Keyboard Shortcuts',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShortcutSection(
                      title: 'Global Navigation',
                      icon: Icons.apps,
                      shortcuts: const [
                        _Shortcut(keys: ['1'], description: 'Go to Home'),
                        _Shortcut(keys: ['2'], description: 'Go to Library'),
                        _Shortcut(keys: ['3'], description: 'Go to Settings'),
                        _Shortcut(
                          keys: ['Esc'],
                          description: 'Focus navigation bar',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _ShortcutSection(
                      title: 'Navigation Controls',
                      icon: Icons.navigation,
                      shortcuts: const [
                        _Shortcut(
                          keys: ['←', '→'],
                          description: 'Navigate between items',
                        ),
                        _Shortcut(
                          keys: ['↑', '↓'],
                          description: 'Navigate up/down in content',
                        ),
                        _Shortcut(
                          keys: ['Enter'],
                          description: 'Select/activate item',
                        ),
                        _Shortcut(
                          keys: ['Space'],
                          description: 'Select/activate item',
                        ),
                        _Shortcut(
                          keys: ['Tab'],
                          description: 'Next focusable element',
                        ),
                        _Shortcut(
                          keys: ['Shift', 'Tab'],
                          description: 'Previous focusable element',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _ShortcutSection(
                      title: 'D-Pad / Remote Control',
                      icon: Icons.gamepad,
                      shortcuts: const [
                        _Shortcut(
                          keys: ['D-pad'],
                          description: 'Navigate in all directions',
                        ),
                        _Shortcut(
                          keys: ['Select'],
                          description: 'Activate focused item',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All interactive elements show a blue border when focused.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_Shortcut> shortcuts;

  const _ShortcutSection({
    required this.title,
    required this.icon,
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...shortcuts.map(
          (shortcut) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ShortcutRow(shortcut: shortcut),
          ),
        ),
      ],
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  final _Shortcut shortcut;

  const _ShortcutRow({required this.shortcut});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: shortcut.keys
                .map(
                  (key) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      key,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Text(shortcut.description, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _Shortcut {
  final List<String> keys;
  final String description;

  const _Shortcut({required this.keys, required this.description});
}

/// Widget that shows a hint about keyboard shortcuts
class KeyboardShortcutHint extends StatelessWidget {
  const KeyboardShortcutHint({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => KeyboardShortcutsDialog.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.keyboard, size: 16, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              'Keyboard shortcuts',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
