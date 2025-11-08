import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for managing library search state
class LibrarySearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Provider for managing library search state across the app
final librarySearchProvider = NotifierProvider<LibrarySearchNotifier, String>(
  () => LibrarySearchNotifier(),
);
