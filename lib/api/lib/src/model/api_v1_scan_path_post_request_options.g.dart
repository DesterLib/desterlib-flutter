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
  final num? maxDepth;
  @override
  final ApiV1ScanPathPostRequestOptionsMediaTypeEnum? mediaType;
  @override
  final BuiltList<String>? fileExtensions;
  @override
  final String? libraryName;
  @override
  final bool? rescan;

  factory _$ApiV1ScanPathPostRequestOptions([
    void Function(ApiV1ScanPathPostRequestOptionsBuilder)? updates,
  ]) => (ApiV1ScanPathPostRequestOptionsBuilder()..update(updates))._build();

  _$ApiV1ScanPathPostRequestOptions._({
    this.maxDepth,
    this.mediaType,
    this.fileExtensions,
    this.libraryName,
    this.rescan,
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
        maxDepth == other.maxDepth &&
        mediaType == other.mediaType &&
        fileExtensions == other.fileExtensions &&
        libraryName == other.libraryName &&
        rescan == other.rescan;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maxDepth.hashCode);
    _$hash = $jc(_$hash, mediaType.hashCode);
    _$hash = $jc(_$hash, fileExtensions.hashCode);
    _$hash = $jc(_$hash, libraryName.hashCode);
    _$hash = $jc(_$hash, rescan.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ScanPathPostRequestOptions')
          ..add('maxDepth', maxDepth)
          ..add('mediaType', mediaType)
          ..add('fileExtensions', fileExtensions)
          ..add('libraryName', libraryName)
          ..add('rescan', rescan))
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

  num? _maxDepth;
  num? get maxDepth => _$this._maxDepth;
  set maxDepth(num? maxDepth) => _$this._maxDepth = maxDepth;

  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? _mediaType;
  ApiV1ScanPathPostRequestOptionsMediaTypeEnum? get mediaType =>
      _$this._mediaType;
  set mediaType(ApiV1ScanPathPostRequestOptionsMediaTypeEnum? mediaType) =>
      _$this._mediaType = mediaType;

  ListBuilder<String>? _fileExtensions;
  ListBuilder<String> get fileExtensions =>
      _$this._fileExtensions ??= ListBuilder<String>();
  set fileExtensions(ListBuilder<String>? fileExtensions) =>
      _$this._fileExtensions = fileExtensions;

  String? _libraryName;
  String? get libraryName => _$this._libraryName;
  set libraryName(String? libraryName) => _$this._libraryName = libraryName;

  bool? _rescan;
  bool? get rescan => _$this._rescan;
  set rescan(bool? rescan) => _$this._rescan = rescan;

  ApiV1ScanPathPostRequestOptionsBuilder() {
    ApiV1ScanPathPostRequestOptions._defaults(this);
  }

  ApiV1ScanPathPostRequestOptionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxDepth = $v.maxDepth;
      _mediaType = $v.mediaType;
      _fileExtensions = $v.fileExtensions?.toBuilder();
      _libraryName = $v.libraryName;
      _rescan = $v.rescan;
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
            maxDepth: maxDepth,
            mediaType: mediaType,
            fileExtensions: _fileExtensions?.build(),
            libraryName: libraryName,
            rescan: rescan,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fileExtensions';
        _fileExtensions?.build();
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
