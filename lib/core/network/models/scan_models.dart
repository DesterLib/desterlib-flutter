import 'settings_models.dart';

/// Scan path request
class ScanPathRequestDto {
  final String path;
  final String? name;
  final String? description;
  final ScanOptionsDto? options;

  const ScanPathRequestDto({
    required this.path,
    this.name,
    this.description,
    this.options,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'path': path};
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    if (options != null) json['options'] = options!.toJson();
    return json;
  }
}

/// Scan options (similar to ScanSettingsDto but for scan requests)
class ScanOptionsDto {
  final String? mediaType;
  final MediaTypeDepthDto? mediaTypeDepth;
  final bool? rescan;
  final bool? followSymlinks;

  const ScanOptionsDto({
    this.mediaType,
    this.mediaTypeDepth,
    this.rescan,
    this.followSymlinks,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (mediaType != null) json['mediaType'] = mediaType;
    if (mediaTypeDepth != null)
      json['mediaTypeDepth'] = mediaTypeDepth!.toJson();
    if (rescan != null) json['rescan'] = rescan;
    if (followSymlinks != null) json['followSymlinks'] = followSymlinks;
    return json;
  }
}

/// Scan response
class ScanResponseDto {
  final String libraryId;
  final String libraryName;
  final String path;
  final String mediaType;
  final int maxDepth;
  final String jobId;
  final String message;

  const ScanResponseDto({
    required this.libraryId,
    required this.libraryName,
    required this.path,
    required this.mediaType,
    required this.maxDepth,
    required this.jobId,
    required this.message,
  });

  factory ScanResponseDto.fromJson(Map<String, dynamic> json) {
    return ScanResponseDto(
      libraryId: json['libraryId'] as String,
      libraryName: json['libraryName'] as String,
      path: json['path'] as String,
      mediaType: json['mediaType'] as String,
      maxDepth: json['maxDepth'] as int,
      jobId: json['jobId'] as String,
      message: json['message'] as String,
    );
  }
}

/// Scan job
class ScanJobDto {
  final String id;
  final String libraryId;
  final String scanPath;
  final String mediaType;
  final String status;
  final String? metadataStatus;
  final int? scannedCount;
  final int? metadataSuccessCount;
  final int? metadataFailedCount;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? metadataStartedAt;
  final DateTime? metadataCompletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScanJobDto({
    required this.id,
    required this.libraryId,
    required this.scanPath,
    required this.mediaType,
    required this.status,
    this.metadataStatus,
    this.scannedCount,
    this.metadataSuccessCount,
    this.metadataFailedCount,
    this.startedAt,
    this.completedAt,
    this.metadataStartedAt,
    this.metadataCompletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScanJobDto.fromJson(Map<String, dynamic> json) {
    return ScanJobDto(
      id: json['id'] as String,
      libraryId: json['libraryId'] as String,
      scanPath: json['scanPath'] as String,
      mediaType: json['mediaType'] as String,
      status: json['status'] as String,
      metadataStatus: json['metadataStatus'] as String?,
      scannedCount: json['scannedCount'] as int?,
      metadataSuccessCount: json['metadataSuccessCount'] as int?,
      metadataFailedCount: json['metadataFailedCount'] as int?,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      metadataStartedAt: json['metadataStartedAt'] != null
          ? DateTime.parse(json['metadataStartedAt'])
          : null,
      metadataCompletedAt: json['metadataCompletedAt'] != null
          ? DateTime.parse(json['metadataCompletedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
