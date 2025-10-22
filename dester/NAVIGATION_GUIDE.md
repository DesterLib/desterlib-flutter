# Navigation Guide

This guide explains how to add keyboard/D-pad navigation to your screens.

## Quick Start

To make any widget navigable with keyboard/D-pad:

### 1. Use `FocusableCard` for Interactive Items

```dart
import 'package:flutter/material.dart';
import '../shared/widgets/focusable_card.dart';

// Wrap your content in a FocusableCard
FocusableCard(
  autofocus: true, // First item should have autofocus
  onTap: () {
    // Handle selection
  },
  child: YourContentWidget(),
)
```

### 2. Example: Grid of Items

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemCount: 12,
  itemBuilder: (context, index) {
    return FocusableCard(
      autofocus: index == 0, // First item gets focus when screen loads
      onTap: () {
        // Handle item selection
      },
      child: YourItemWidget(),
    );
  },
)
```

### 3. Example: List of Items

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return FocusableCard(
      autofocus: index == 0,
      onTap: () {
        // Handle item selection
      },
      child: ListTile(
        title: Text(items[index]),
      ),
    );
  },
)
```

## Navigation Keys

### Automatic (Built-in):

- **Arrow Keys**: Navigate between items (up/down/left/right)
- **Enter/Space**: Activate focused item
- **Escape**: Return to top navigation
- **↑ Up** from first row: Jumps to navigation bar
- **↓ Down** from navigation: Jumps to first focusable item

### Custom Shortcuts (Already configured):

- **1 or Numpad 1**: Navigate to Home
- **2 or Numpad 2**: Navigate to Library
- **3 or Numpad 3**: Navigate to Settings
- **Shift + ?**: Show keyboard shortcuts dialog

## Important Rules

1. **Always set `autofocus: true`** on the first item of your screen
2. **Don't add AppBar** to your screens - `AppShell` handles navigation
3. **Wrap your screen in Scaffold** - but no appBar needed
4. **Use FocusableCard** for all interactive/selectable items

## Screen Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/focusable_card.dart';

class YourScreen extends ConsumerWidget {
  const YourScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          // Your layout configuration
          itemBuilder: (context, index) {
            return FocusableCard(
              autofocus: index == 0, // Important!
              onTap: () {
                // Handle selection
              },
              child: YourContent(),
            );
          },
        ),
      ),
    );
  }
}
```

## How It Works

1. **AppShell** manages the top navigation bar and global key handlers
2. **FocusableCard** provides visual feedback and handles arrow key navigation
3. **Global handlers** manage navigation between navbar and content
4. **Event bubbling** allows up arrow from first row to return to navbar

That's it! Just use `FocusableCard` and set `autofocus: true` on the first item.
