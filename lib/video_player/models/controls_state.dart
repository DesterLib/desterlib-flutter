import 'package:equatable/equatable.dart';

enum TrackMenuType { none, audio, subtitle }

/// State for video player controls
class ControlsState extends Equatable {
  final bool isVisible;
  final bool isDragging;
  final double? dragValue;
  final TrackMenuType activeMenu;

  const ControlsState({
    this.isVisible = true,
    this.isDragging = false,
    this.dragValue,
    this.activeMenu = TrackMenuType.none,
  });

  ControlsState copyWith({
    bool? isVisible,
    bool? isDragging,
    double? dragValue,
    TrackMenuType? activeMenu,
  }) {
    return ControlsState(
      isVisible: isVisible ?? this.isVisible,
      isDragging: isDragging ?? this.isDragging,
      dragValue: dragValue ?? this.dragValue,
      activeMenu: activeMenu ?? this.activeMenu,
    );
  }

  @override
  List<Object?> get props => [isVisible, isDragging, dragValue, activeMenu];
}
