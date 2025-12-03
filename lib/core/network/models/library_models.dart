/// Library model
class LibraryDto {
  final String id;
  final String name;
  final String libraryPath;
  final bool isLibrary;
  final String libraryType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LibraryDto({
    required this.id,
    required this.name,
    required this.libraryPath,
    required this.isLibrary,
    required this.libraryType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LibraryDto.fromJson(Map<String, dynamic> json) {
    return LibraryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      libraryPath: json['libraryPath'] as String,
      isLibrary: json['isLibrary'] as bool,
      libraryType: json['libraryType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Update library request
class UpdateLibraryRequestDto {
  final String name;
  final String? path;

  const UpdateLibraryRequestDto({required this.name, this.path});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'name': name};
    if (path != null) json['path'] = path;
    return json;
  }
}

/// Delete library request
class DeleteLibraryRequestDto {
  final bool deleteMedia;

  const DeleteLibraryRequestDto({required this.deleteMedia});

  Map<String, dynamic> toJson() => {'deleteMedia': deleteMedia};
}
