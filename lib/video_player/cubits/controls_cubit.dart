import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/controls_state.dart';

/// Cubit for managing video controls visibility and interactions
class ControlsCubit extends Cubit<ControlsState> {
  Timer? _hideTimer;

  ControlsCubit() : super(const ControlsState(isVisible: true)) {
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (!state.isDragging) {
        emit(state.copyWith(isVisible: false));
      }
    });
  }

  void showControls() {
    emit(state.copyWith(isVisible: true));
    _startHideTimer();
  }

  void hideControls() {
    emit(state.copyWith(isVisible: false));
  }

  void toggleControls() {
    if (state.isVisible) {
      hideControls();
    } else {
      showControls();
    }
  }

  void setDragging(bool isDragging, {double? dragValue}) {
    emit(state.copyWith(isDragging: isDragging, dragValue: dragValue));

    if (!isDragging) {
      _startHideTimer();
    }
  }

  void setActiveMenu(TrackMenuType menuType) {
    _hideTimer?.cancel();
    emit(state.copyWith(activeMenu: menuType));

    if (menuType == TrackMenuType.none) {
      _startHideTimer();
    }
  }

  void closeMenus() {
    emit(state.copyWith(activeMenu: TrackMenuType.none));
    _startHideTimer();
  }

  void toggleAudioMenu() {
    final newMenu = state.activeMenu == TrackMenuType.audio
        ? TrackMenuType.none
        : TrackMenuType.audio;
    setActiveMenu(newMenu);
  }

  void toggleSubtitleMenu() {
    final newMenu = state.activeMenu == TrackMenuType.subtitle
        ? TrackMenuType.none
        : TrackMenuType.subtitle;
    setActiveMenu(newMenu);
  }

  @override
  Future<void> close() {
    _hideTimer?.cancel();
    return super.close();
  }
}
