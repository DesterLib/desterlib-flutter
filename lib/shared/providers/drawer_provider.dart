import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Drawer content types
enum DrawerContentType { none, tmdbApiKey, tmdbRequired }

/// Drawer state
class DrawerState {
  final DrawerContentType contentType;
  final Map<String, dynamic> data;

  const DrawerState({
    this.contentType = DrawerContentType.none,
    this.data = const {},
  });

  DrawerState copyWith({
    DrawerContentType? contentType,
    Map<String, dynamic>? data,
  }) {
    return DrawerState(
      contentType: contentType ?? this.contentType,
      data: data ?? this.data,
    );
  }

  bool get isOpen => contentType != DrawerContentType.none;
}

/// Drawer state provider
final drawerProvider = NotifierProvider<DrawerNotifier, DrawerState>(() {
  return DrawerNotifier();
});

/// Drawer state notifier
class DrawerNotifier extends Notifier<DrawerState> {
  @override
  DrawerState build() {
    return const DrawerState();
  }

  /// Open drawer with specific content
  void openDrawer(DrawerContentType contentType, {Map<String, dynamic>? data}) {
    state = state.copyWith(contentType: contentType, data: data ?? {});
  }

  /// Close drawer
  void closeDrawer() {
    state = const DrawerState();
  }

  /// Update drawer data
  void updateData(Map<String, dynamic> data) {
    state = state.copyWith(data: data);
  }
}
