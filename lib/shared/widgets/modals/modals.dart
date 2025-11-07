/// Unified Modal/Drawer System
///
/// This file exports all modal-related components for easy importing.
/// The system uses a config-based approach to reduce code duplication
/// and automatically adapts between modal (desktop) and drawer (mobile) layouts.
///
/// Usage:
/// ```dart
/// import 'package:dester/shared/widgets/modals/modals.dart';
///
/// // Base modal system (auto-adapts to screen size)
/// showSettingsModal(...)
///
/// // Config-based system (declarative approach)
/// showConfigurableModal(
///   context: context,
///   config: ModalConfig(...),
/// )
///
/// // Reusable components
/// SettingsModalBanner(...)
/// SettingsModalTextField(...)
/// SettingsModalActions(...)
/// ```
library;

export 'settings_modal_wrapper.dart';
export 'configurable_modal.dart';
