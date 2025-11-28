/// Scan settings entity representing default scan configuration
class ScanSettings {
  final String? mediaType;
  final int? maxDepth;
  final int? movieDepth;
  final int? tvDepth;
  final List<String>? fileExtensions;
  final String? filenamePattern;
  final String? excludePattern;
  final String? includePattern;
  final String? directoryPattern;
  final List<String>? excludeDirectories;
  final List<String>? includeDirectories;
  final bool? rescan;
  final bool? batchScan;
  final int? minFileSize;
  final int? maxFileSize;
  final bool? followSymlinks;

  /// Default scan settings
  static const ScanSettings defaults = ScanSettings(
    rescan: false,
    batchScan: false,
    followSymlinks: true,
    movieDepth: 2,
    tvDepth: 4,
  );

  const ScanSettings({
    this.mediaType,
    this.maxDepth,
    this.movieDepth,
    this.tvDepth,
    this.fileExtensions,
    this.filenamePattern,
    this.excludePattern,
    this.includePattern,
    this.directoryPattern,
    this.excludeDirectories,
    this.includeDirectories,
    this.rescan,
    this.batchScan,
    this.minFileSize,
    this.maxFileSize,
    this.followSymlinks,
  });

  /// Create a copy with updated values
  ScanSettings copyWith({
    String? mediaType,
    int? maxDepth,
    int? movieDepth,
    int? tvDepth,
    List<String>? fileExtensions,
    String? filenamePattern,
    String? excludePattern,
    String? includePattern,
    String? directoryPattern,
    List<String>? excludeDirectories,
    List<String>? includeDirectories,
    bool? rescan,
    bool? batchScan,
    int? minFileSize,
    int? maxFileSize,
    bool? followSymlinks,
  }) {
    return ScanSettings(
      mediaType: mediaType ?? this.mediaType,
      maxDepth: maxDepth ?? this.maxDepth,
      movieDepth: movieDepth ?? this.movieDepth,
      tvDepth: tvDepth ?? this.tvDepth,
      fileExtensions: fileExtensions ?? this.fileExtensions,
      filenamePattern: filenamePattern ?? this.filenamePattern,
      excludePattern: excludePattern ?? this.excludePattern,
      includePattern: includePattern ?? this.includePattern,
      directoryPattern: directoryPattern ?? this.directoryPattern,
      excludeDirectories: excludeDirectories ?? this.excludeDirectories,
      includeDirectories: includeDirectories ?? this.includeDirectories,
      rescan: rescan ?? this.rescan,
      batchScan: batchScan ?? this.batchScan,
      minFileSize: minFileSize ?? this.minFileSize,
      maxFileSize: maxFileSize ?? this.maxFileSize,
      followSymlinks: followSymlinks ?? this.followSymlinks,
    );
  }
}
