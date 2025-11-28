// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_scan_path_post_request_options.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1ScanPathPostRequestOptionsMediaTypeEnum
_$apiV1ScanPathPostRequestOptionsMediaTypeEnum_movie =
    const ApiV1ScanPathPostRequestOptionsMediaTypeEnum._('movie');
const ApiV1ScanPathPostRequestOptionsMediaTypeEnum
_$apiV1ScanPathPostRequestOptionsMediaTypeEnum_tv =
    const ApiV1ScanPathPostRequestOptionsMediaTypeEnum._('tv');

ApiV1ScanPathPostRequestOptionsMediaTypeEnum
_$apiV1ScanPathPostRequestOptionsMediaTypeEnumValueOf(String name) {
  switch (name) {
    case 'movie':
      return _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_movie;
    case 'tv':
      return _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_tv;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1ScanPathPostRequestOptionsMediaTypeEnum>
_$apiV1ScanPathPostRequestOptionsMediaTypeEnumValues =
    BuiltSet<ApiV1ScanPathPostRequestOptionsMediaTypeEnum>(
      const <ApiV1ScanPathPostRequestOptionsMediaTypeEnum>[
        _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_movie,
        _$apiV1ScanPathPostRequestOptionsMediaTypeEnum_tv,
      ],
    );

Serializer<ApiV1ScanPathPostRequestOptionsMediaTypeEnum>
_$apiV1ScanPathPostRequestOptionsMediaTypeEnumSerializer =
    _$ApiV1ScanPathPostRequestOptionsMediaTypeEnumSerializer();

class _$ApiV1ScanPathPostRequestOptionsMediaTypeEnumSerializer
    implements
        PrimitiveSerializer<ApiV1ScanPathPostRequestOptionsMediaTypeEnum> {
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
    ApiV1ScanPathPostRequestOptionsMediaTypeEnum,
  ];
  @override
  final String wireName = 'ApiV1ScanPathPostRequestOptionsMediaTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ScanPathPostRequestOptionsMediaTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ApiV1ScanPathPostRequestOptionsMediaTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ApiV1ScanPathPostRequestOptionsMediaTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ApiV1ScanPathPostRequestOptions
    extends ApiV1ScanPathPostRequestOptions {
  @override
  final ApiV1ScanPathPostRequestOptionsMediaTypeEnum? mediaType;
  @override
  final ApiV1ScanPathPostRequestOptionsMediaTypeDepth? mediaTypeDepth;
  @override
  final String? filenamePattern;
  @override
  final String? directoryPattern;
  @override
  final bool? rescan;
  @override
  final bool? batchScan;
  @override
  final bool? followSymlinks;

  factory _$ApiV1ScanPathPostRequestOptions([
    void Function(ApiV1ScanPathPostRequestOptionsBuilder)? updates,
  ]) => (ApiV1ScanPathPostRequestOptionsBuilder()..update(updates))._build();

  _$ApiV1ScanPathPostRequestOptions._({
    this.mediaType,
    this.mediaTypeDepth,
    this.filenamePattern,
    this.directoryPattern,
    this.rescan,
    this.batchScan,
    this.followSymlinks,
  }) : super._();
  @override
  ApiV1ScanPathPostRequestOptions rebuild(
    void Function(ApiV1ScanPathPostRequestOptionsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ApiV1ScanPathPostRequestOptionsBuilder toBuilder() =>
      ApiV1ScanPathPostRequestOptionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ScanPathPostRequestOptions &&
        mediaType == other.mediaType &&
        mediaTypeDepth == other.mediaTypeDepth &&
        filenamePattern == other.filenamePattern &&
        directoryPattern == other.directoryPattern &&
        rescan == other.rescan &&
        batchScan == other.batchScan &&
        followSymlinks == other.followSymlinks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mediaType.hashCode);
    _$hash = $jc(_$hash, mediaTypeDepth.hashCode);
    _$hash = $jc(_$hash, filenamePattern.hashCode);
    _$hash = $jc(_$hash, directoryPattern.hashCode);
    _$hash = $jc(_$hash, rescan.hashCode);
    _$hash = $jc(_$hash, batchScan.hashCode);
    _$hash = $jc(_$hash, followSymlinks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPostRequestOptions')
          ..add('mediaType', mediaType)
          ..add('mediaTypeDepth', mediaTypeDepth)
          ..add('filenamePattern', filenamePattern)
          ..add('directoryPattern', directoryPattern)
          ..add('rescan', rescan)
          ..add('batchScan', batchScan)
          ..add('followSymlinks', followSymlinks))
        .toString();
  }
}

class ApiV1ScanPathPostRequestOptionsBuilder
    implements
        Builder<
          ApiV1ScanPathPostRequestOptions,
          ApiV1ScanPathPostRequestOptionsBuilder
        > {
  _$ApiV1ScanPathPostRequestOptions? _$v;

  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? _mediaType;
  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? get mediaType =>
      _$this._mediaType;
  set mediaType(ApiV1ScanPathPostRequestOptionsMediaTypeEnum? mediaType) =>
      _$this._mediaType = mediaType;

  ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder? _mediaTypeDepth;
  ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder get mediaTypeDepth =>
      _$this._mediaTypeDepth ??=
          ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder();
  set mediaTypeDepth(
    ApiV1ScanPathPostRequestOptionsMediaTypeDepthBuilder? mediaTypeDepth,
  ) => _$this._mediaTypeDepth = mediaTypeDepth;

  String? _filenamePattern;
  String? get filenamePattern => _$this._filenamePattern;
  set filenamePattern(String? filenamePattern) =>
      _$this._filenamePattern = filenamePattern;

  String? _directoryPattern;
  String? get directoryPattern => _$this._directoryPattern;
  set directoryPattern(String? directoryPattern) =>
      _$this._directoryPattern = directoryPattern;

  bool? _rescan;
  bool? get rescan => _$this._rescan;
  set rescan(bool? rescan) => _$this._rescan = rescan;

  bool? _batchScan;
  bool? get batchScan => _$this._batchScan;
  set batchScan(bool? batchScan) => _$this._batchScan = batchScan;

  bool? _followSymlinks;
  bool? get followSymlinks => _$this._followSymlinks;
  set followSymlinks(bool? followSymlinks) =>
      _$this._followSymlinks = followSymlinks;

  ApiV1ScanPathPostRequestOptionsBuilder() {
    ApiV1ScanPathPostRequestOptions._defaults(this);
  }

  ApiV1ScanPathPostRequestOptionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mediaType = $v.mediaType;
      _mediaTypeDepth = $v.mediaTypeDepth?.toBuilder();
      _filenamePattern = $v.filenamePattern;
      _directoryPattern = $v.directoryPattern;
      _rescan = $v.rescan;
      _batchScan = $v.batchScan;
      _followSymlinks = $v.followSymlinks;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ScanPathPostRequestOptions other) {
    _$v = other as _$ApiV1ScanPathPostRequestOptions;
  }

  @override
  void update(void Function(ApiV1ScanPathPostRequestOptionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ScanPathPostRequestOptions build() => _build();

  _$ApiV1ScanPathPostRequestOptions _build() {
    _$ApiV1ScanPathPostRequestOptions _$result;
    try {
      _$result =
          _$v ??
          _$ApiV1ScanPathPostRequestOptions._(
            mediaType: mediaType,
            mediaTypeDepth: _mediaTypeDepth?.build(),
            filenamePattern: filenamePattern,
            directoryPattern: directoryPattern,
            rescan: rescan,
            batchScan: batchScan,
            followSymlinks: followSymlinks,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mediaTypeDepth';
        _mediaTypeDepth?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApiV1ScanPathPostRequestOptions',
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
