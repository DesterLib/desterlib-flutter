import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {}

class SettingsRefreshRequested extends SettingsEvent {}

class LibraryCreateRequested extends SettingsEvent {
  final String name;
  final String path;
  final String type;

  LibraryCreateRequested({
    required this.name,
    required this.path,
    required this.type,
  });

  @override
  List<Object> get props => [name, path, type];
}

class LibraryUpdateRequested extends SettingsEvent {
  final String id;
  final String name;
  final String path;
  final String type;

  LibraryUpdateRequested({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
  });

  @override
  List<Object> get props => [id, name, path, type];
}

class LibraryDeleteRequested extends SettingsEvent {
  final String id;

  LibraryDeleteRequested({required this.id});

  @override
  List<Object> get props => [id];
}

class LibraryScanRequested extends SettingsEvent {
  final String libraryId;

  LibraryScanRequested({required this.libraryId});

  @override
  List<Object> get props => [libraryId];
}

class AppSettingsUpdateRequested extends SettingsEvent {
  final String? tmdbApiKey;
  final int? port;
  final bool? enableRouteGuards;

  AppSettingsUpdateRequested({
    this.tmdbApiKey,
    this.port,
    this.enableRouteGuards,
  });

  @override
  List<Object?> get props => [tmdbApiKey, port, enableRouteGuards];
}
