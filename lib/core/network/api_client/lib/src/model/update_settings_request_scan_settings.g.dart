// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_settings_request_scan_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateSettingsRequestScanSettingsMediaTypeEnum
_$updateSettingsRequestScanSettingsMediaTypeEnum_movie =
    const UpdateSettingsRequestScanSettingsMediaTypeEnum._('movie');
const UpdateSettingsRequestScanSettingsMediaTypeEnum
_$updateSettingsRequestScanSettingsMediaTypeEnum_tv =
    const UpdateSettingsRequestScanSettingsMediaTypeEnum._('tv');

UpdateSettingsRequestScanSettingsMediaTypeEnum
_$updateSettingsRequestScanSettingsMediaTypeEnumValueOf(String name) {
  switch (name) {
    case 'movie':
      return _$updateSettingsRequestScanSettingsMediaTypeEnum_movie;
    case 'tv':
      return _$updateSettingsRequestScanSettingsMediaTypeEnum_tv;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateSettingsRequestScanSettingsMediaTypeEnum>
_$updateSettingsRequestScanSettingsMediaTypeEnumValues =
    BuiltSet<UpdateSettingsRequestScanSettingsMediaTypeEnum>(
      const <UpdateSettingsRequestScanSettingsMediaTypeEnum>[
        _$updateSettingsRequestScanSettingsMediaTypeEnum_movie,
        _$updateSettingsRequestScanSettingsMediaTypeEnum_tv,
      ],
    );

Serializer<UpdateSettingsRequestScanSettingsMediaTypeEnum>
_$updateSettingsRequestScanSettingsMediaTypeEnumSerializer =
    _$UpdateSettingsRequestScanSettingsMediaTypeEnumSerializer();

class _$UpdateSettingsRequestScanSettingsMediaTypeEnumSerializer
    implements
        PrimitiveSerializer<UpdateSettingsRequestScanSettingsMediaTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'movie': 'movie',
    'tv': 'tv',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'movie': 'movie',
    'tv': 'tv',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UpdateSettingsRequestScanSettingsMediaTypeEnum,
  ];
  @override
  final String wireName = 'UpdateSettingsRequestScanSettingsMediaTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    UpdateSettingsRequestScanSettingsMediaTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  UpdateSettingsRequestScanSettingsMediaTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => UpdateSettingsRequestScanSettingsMediaTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$UpdateSettingsRequestScanSettings
    extends UpdateSettingsRequestScanSettings {
  @override
  final UpdateSettingsRequestScanSettingsMediaTypeEnum? mediaType;
  @override
  final num? maxDepth;
  @override
  final PublicSettingsScanSettingsMediaTypeDepth? mediaTypeDepth;
  @override
  final BuiltList<String>? fileExtensions;
  @override
  final String? filenamePattern;
  @override
  final String? excludePattern;
  @override
  final String? includePattern;
  @override
  final String? directoryPattern;
  @override
  final BuiltList<String>? excludeDirectories;
  @override
  final BuiltList<String>? includeDirectories;
  @override
  final bool? rescan;
  @override
  final bool? batchScan;
  @override
  final num? minFileSize;
  @override
  final num? maxFileSize;
  @override
  final bool? followSymlinks;

  factory _$UpdateSettingsRequestScanSettings([
    void Function(UpdateSettingsRequestScanSettingsBuilder)? updates,
  ]) => (UpdateSettingsRequestScanSettingsBuilder()..update(updates))._build();

  _$UpdateSettingsRequestScanSettings._({
    this.mediaType,
    this.maxDepth,
    this.mediaTypeDepth,
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
  }) : super._();
  @override
  UpdateSettingsRequestScanSettings rebuild(
    void Function(UpdateSettingsRequestScanSettingsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateSettingsRequestScanSettingsBuilder toBuilder() =>
      UpdateSettingsRequestScanSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateSettingsRequestScanSettings &&
        mediaType == other.mediaType &&
        maxDepth == other.maxDepth &&
        mediaTypeDepth == other.mediaTypeDepth &&
        fileExtensions == other.fileExtensions &&
        filenamePattern == other.filenamePattern &&
        excludePattern == other.excludePattern &&
        includePattern == other.includePattern &&
        directoryPattern == other.directoryPattern &&
        excludeDirectories == other.excludeDirectories &&
        includeDirectories == other.includeDirectories &&
        rescan == other.rescan &&
        batchScan == other.batchScan &&
        minFileSize == other.minFileSize &&
        maxFileSize == other.maxFileSize &&
        followSymlinks == other.followSymlinks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mediaType.hashCode);
    _$hash = $jc(_$hash, maxDepth.hashCode);
    _$hash = $jc(_$hash, mediaTypeDepth.hashCode);
    _$hash = $jc(_$hash, fileExtensions.hashCode);
    _$hash = $jc(_$hash, filenamePattern.hashCode);
    _$hash = $jc(_$hash, excludePattern.hashCode);
    _$hash = $jc(_$hash, includePattern.hashCode);
    _$hash = $jc(_$hash, directoryPattern.hashCode);
    _$hash = $jc(_$hash, excludeDirectories.hashCode);
    _$hash = $jc(_$hash, includeDirectories.hashCode);
    _$hash = $jc(_$hash, rescan.hashCode);
    _$hash = $jc(_$hash, batchScan.hashCode);
    _$hash = $jc(_$hash, minFileSize.hashCode);
    _$hash = $jc(_$hash, maxFileSize.hashCode);
    _$hash = $jc(_$hash, followSymlinks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateSettingsRequestScanSettings')
          ..add('mediaType', mediaType)
          ..add('maxDepth', maxDepth)
          ..add('mediaTypeDepth', mediaTypeDepth)
          ..add('fileExtensions', fileExtensions)
          ..add('filenamePattern', filenamePattern)
          ..add('excludePattern', excludePattern)
          ..add('includePattern', includePattern)
          ..add('directoryPattern', directoryPattern)
          ..add('excludeDirectories', excludeDirectories)
          ..add('includeDirectories', includeDirectories)
          ..add('rescan', rescan)
          ..add('batchScan', batchScan)
          ..add('minFileSize', minFileSize)
          ..add('maxFileSize', maxFileSize)
          ..add('followSymlinks', followSymlinks))
        .toString();
  }
}

class UpdateSettingsRequestScanSettingsBuilder
    implements
        Builder<
          UpdateSettingsRequestScanSettings,
          UpdateSettingsRequestScanSettingsBuilder
        > {
  _$UpdateSettingsRequestScanSettings? _$v;

  UpdateSettingsRequestScanSettingsMediaTypeEnum? _mediaType;
  UpdateSettingsRequestScanSettingsMediaTypeEnum? get mediaType =>
      _$this._mediaType;
  set mediaType(UpdateSettingsRequestScanSettingsMediaTypeEnum? mediaType) =>
      _$this._mediaType = mediaType;

  num? _maxDepth;
  num? get maxDepth => _$this._maxDepth;
  set maxDepth(num? maxDepth) => _$this._maxDepth = maxDepth;

  PublicSettingsScanSettingsMediaTypeDepthBuilder? _mediaTypeDepth;
  PublicSettingsScanSettingsMediaTypeDepthBuilder get mediaTypeDepth =>
      _$this._mediaTypeDepth ??=
          PublicSettingsScanSettingsMediaTypeDepthBuilder();
  set mediaTypeDepth(
    PublicSettingsScanSettingsMediaTypeDepthBuilder? mediaTypeDepth,
  ) => _$this._mediaTypeDepth = mediaTypeDepth;

  ListBuilder<String>? _fileExtensions;
  ListBuilder<String> get fileExtensions =>
      _$this._fileExtensions ??= ListBuilder<String>();
  set fileExtensions(ListBuilder<String>? fileExtensions) =>
      _$this._fileExtensions = fileExtensions;

  String? _filenamePattern;
  String? get filenamePattern => _$this._filenamePattern;
  set filenamePattern(String? filenamePattern) =>
      _$this._filenamePattern = filenamePattern;

  String? _excludePattern;
  String? get excludePattern => _$this._excludePattern;
  set excludePattern(String? excludePattern) =>
      _$this._excludePattern = excludePattern;

  String? _includePattern;
  String? get includePattern => _$this._includePattern;
  set includePattern(String? includePattern) =>
      _$this._includePattern = includePattern;

  String? _directoryPattern;
  String? get directoryPattern => _$this._directoryPattern;
  set directoryPattern(String? directoryPattern) =>
      _$this._directoryPattern = directoryPattern;

  ListBuilder<String>? _excludeDirectories;
  ListBuilder<String> get excludeDirectories =>
      _$this._excludeDirectories ??= ListBuilder<String>();
  set excludeDirectories(ListBuilder<String>? excludeDirectories) =>
      _$this._excludeDirectories = excludeDirectories;

  ListBuilder<String>? _includeDirectories;
  ListBuilder<String> get includeDirectories =>
      _$this._includeDirectories ??= ListBuilder<String>();
  set includeDirectories(ListBuilder<String>? includeDirectories) =>
      _$this._includeDirectories = includeDirectories;

  bool? _rescan;
  bool? get rescan => _$this._rescan;
  set rescan(bool? rescan) => _$this._rescan = rescan;

  bool? _batchScan;
  bool? get batchScan => _$this._batchScan;
  set batchScan(bool? batchScan) => _$this._batchScan = batchScan;

  num? _minFileSize;
  num? get minFileSize => _$this._minFileSize;
  set minFileSize(num? minFileSize) => _$this._minFileSize = minFileSize;

  num? _maxFileSize;
  num? get maxFileSize => _$this._maxFileSize;
  set maxFileSize(num? maxFileSize) => _$this._maxFileSize = maxFileSize;

  bool? _followSymlinks;
  bool? get followSymlinks => _$this._followSymlinks;
  set followSymlinks(bool? followSymlinks) =>
      _$this._followSymlinks = followSymlinks;

  UpdateSettingsRequestScanSettingsBuilder() {
    UpdateSettingsRequestScanSettings._defaults(this);
  }

  UpdateSettingsRequestScanSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mediaType = $v.mediaType;
      _maxDepth = $v.maxDepth;
      _mediaTypeDepth = $v.mediaTypeDepth?.toBuilder();
      _fileExtensions = $v.fileExtensions?.toBuilder();
      _filenamePattern = $v.filenamePattern;
      _excludePattern = $v.excludePattern;
      _includePattern = $v.includePattern;
      _directoryPattern = $v.directoryPattern;
      _excludeDirectories = $v.excludeDirectories?.toBuilder();
      _includeDirectories = $v.includeDirectories?.toBuilder();
      _rescan = $v.rescan;
      _batchScan = $v.batchScan;
      _minFileSize = $v.minFileSize;
      _maxFileSize = $v.maxFileSize;
      _followSymlinks = $v.followSymlinks;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateSettingsRequestScanSettings other) {
    _$v = other as _$UpdateSettingsRequestScanSettings;
  }

  @override
  void update(
    void Function(UpdateSettingsRequestScanSettingsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  UpdateSettingsRequestScanSettings build() => _build();

  _$UpdateSettingsRequestScanSettings _build() {
    _$UpdateSettingsRequestScanSettings _$result;
    try {
      _$result =
          _$v ??
          _$UpdateSettingsRequestScanSettings._(
            mediaType: mediaType,
            maxDepth: maxDepth,
            mediaTypeDepth: _mediaTypeDepth?.build(),
            fileExtensions: _fileExtensions?.build(),
            filenamePattern: filenamePattern,
            excludePattern: excludePattern,
            includePattern: includePattern,
            directoryPattern: directoryPattern,
            excludeDirectories: _excludeDirectories?.build(),
            includeDirectories: _includeDirectories?.build(),
            rescan: rescan,
            batchScan: batchScan,
            minFileSize: minFileSize,
            maxFileSize: maxFileSize,
            followSymlinks: followSymlinks,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mediaTypeDepth';
        _mediaTypeDepth?.build();
        _$failedField = 'fileExtensions';
        _fileExtensions?.build();

        _$failedField = 'excludeDirectories';
        _excludeDirectories?.build();
        _$failedField = 'includeDirectories';
        _includeDirectories?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateSettingsRequestScanSettings',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
