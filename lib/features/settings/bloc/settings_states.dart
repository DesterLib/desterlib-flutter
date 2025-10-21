import 'package:equatable/equatable.dart';
import '../repo/settings_repository.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final List<Library> libraries;
  final AppSettings appSettings;

  SettingsLoaded({required this.libraries, required this.appSettings});

  @override
  List<Object> get props => [libraries, appSettings];
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError({required this.message});

  @override
  List<Object> get props => [message];
}

class SettingsOperationInProgress extends SettingsState {
  final List<Library> libraries;
  final AppSettings appSettings;
  final String operation;

  SettingsOperationInProgress({
    required this.libraries,
    required this.appSettings,
    required this.operation,
  });

  @override
  List<Object> get props => [libraries, appSettings, operation];
}

class SettingsOperationSuccess extends SettingsState {
  final List<Library> libraries;
  final AppSettings appSettings;
  final String message;

  SettingsOperationSuccess({
    required this.libraries,
    required this.appSettings,
    required this.message,
  });

  @override
  List<Object> get props => [libraries, appSettings, message];
}
